//
//  MyShelfViewModel.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//
import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth  // 🔥 TAMBAHKAN INI!

@MainActor
class MyShelfViewModel: ObservableObject {
    @Published var activeTab: ShelfStatus = .available
    @Published var viewMode: ViewMode = .card
    @Published var shelfBooks: [Book] = []
    private var db = Firestore.firestore()
    // Filter Configuration Engine Bindings
    @Published var selectedGenreFilter: String = "All"
    @Published var selectedAuthorFilter: String = "All"
    @Published var selectedPublisherFilter: String = "All"
    @Published var selectedPageFilter: PageRangeOption = .all
    @Published var selectedSortOption: SortOption = .newest
    
    @Published var apiSearchQuery: String = ""
    @Published var apiResults: [OpenLibraryDoc] = []
    @Published var isSearchingAPI: Bool = false
    
    private let apiService = OpenLibraryService()
    private var cancellables = Set<AnyCancellable>()
    private var shelfListener: ListenerRegistration?
    
    init() {
        $apiSearchQuery
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                if query.count > 2 {
                    Task { await self.triggerBookSearch(query: query) }
                } else {
                    self.apiResults = []
                }
            }
            .store(in: &cancellables)
        
        // Fetch books immediately when the page loads
        self.fetchMyBooks()
    }
    // Dynamic Filter Option Lists Generated Directly from Shelf Inventory Content
    var uniqueGenres: [String] {
        ["All"] + Array(Set(shelfBooks.map { $0.genre })).sorted()
    }
    
    var uniqueAuthors: [String] {
        ["All"] + Array(Set(shelfBooks.map { $0.author })).sorted()
    }
    
    var uniquePublishers: [String] {
        ["All"] + Array(Set(shelfBooks.map { $0.publisher })).sorted()
    }
    
    // Dynamic Evaluated Book Array Filter and Sort Query Engine Output
    var filteredBooks: [Book] {
        var items = shelfBooks.filter { $0.status == activeTab }
        
        // 1. Text Field Category Matching Filter Evaluators
        if selectedGenreFilter != "All" {
            items = items.filter { $0.genre == selectedGenreFilter }
        }
        if selectedAuthorFilter != "All" {
            items = items.filter { $0.author == selectedAuthorFilter }
        }
        if selectedPublisherFilter != "All" {
            items = items.filter { $0.publisher == selectedPublisherFilter }
        }
        
        // 2. Numerical Range Matching Evaluation (Halaman)
        switch selectedPageFilter {
        case .all: break
        case .short: items = items.filter { $0.pageCount < 150 }
        case .medium: items = items.filter { $0.pageCount >= 150 && $0.pageCount <= 400 }
        case .long: items = items.filter { $0.pageCount > 400 }
        }
        
        // 3. Sequential Sorting Engine Output Selection
        switch selectedSortOption {
        case .newest:
            return items.sorted { $0.dateAdded > $1.dateAdded }
        case .alphabetical:
            return items.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        }
    }
    
    func triggerBookSearch(query: String) async {
        isSearchingAPI = true
        do {
            self.apiResults = try await apiService.searchBooks(query: query)
        } catch {
            print("API Query Error: \(error.localizedDescription)")
            self.apiResults = []
        }
        isSearchingAPI = false
    }
    
    // 🔥 FUNGSI ADD BOOK YANG SUDAH DIPERBAIKI
    func addNewBookToShelf(title: String, author: String, genre: String, publisher: String, pageCount: Int, quote: String, coverUrl: String?) {
        
        // 🔥 AMBIL USER YANG SEDANG LOGIN
        guard let currentUser = Auth.auth().currentUser else {
            print("ERROR: Tidak ada user yang login! Buku tidak bisa disimpan.")
            return
        }
        
        let ownerId = currentUser.uid  // 🔥 UID ASLI DARI USER YANG LOGIN
        
        // 1. OPTIMISTIC UI: Tambahkan buku ke array lokal terlebih dahulu
        let newBook = Book(
            id: UUID(),
            firestoreID: nil,
            title: title,
            author: author,
            genre: genre,
            publisher: publisher.isEmpty ? "Unknown Publisher" : publisher,
            pageCount: pageCount,
            quote: quote.isEmpty ? "Mystery book entry." : quote,
            coverUrl: coverUrl,
            isAvailable: true,
            ownerId: ownerId,  // 🔥 PAKAI UID ASLI
            status: .available,
            dateAdded: Date()
        )
        self.shelfBooks.append(newBook)
        
        // 2. Package the data for Firebase
        let bookData: [String: Any] = [
            "title": title,
            "author": author,
            "genre": genre,
            "publisher": publisher.isEmpty ? "Unknown Publisher" : publisher,
            "pageCount": pageCount,
            "quote": quote.isEmpty ? "Mystery book entry." : quote,
            "coverUrl": coverUrl ?? "",
            "status": ShelfStatus.available.rawValue,
            "dateAdded": Timestamp(date: Date()),
            "isAvailable": true,
            "ownerId": ownerId  // 🔥 PAKAI UID ASLI
        ]
        
        // 3. Send it to the "books" collection in Firestore
        db.collection("books").addDocument(data: bookData) { error in
            if let error = error {
                print("❌ FIREBASE ERROR: \(error.localizedDescription)")
            } else {
                print("✅ FIREBASE SUCCESS! Book successfully saved to the database! OwnerId: \(ownerId)")
                
                // 4. Re-fetch the books from Firebase to get the actual firestoreID
                self.fetchMyBooks()
            }
        }
    }
    
    // 🔥 FUNGSI FETCH BOOKS YANG SUDAH DIPERBAIKI
    func fetchMyBooks() {
         // Hapus pendengar lama jika ada, agar tidak double
         shelfListener?.remove()

      
       guard let currentUser = Auth.auth().currentUser else {
            print("ERROR: Tidak ada user yang login! Tidak bisa mengambil data buku.")
            self.shelfBooks = []
            return
        }
        
        // 🔥 FILTER: HANYA buku milik user yang sedang login
        db.collection("books")
            .whereField("ownerId", isEqualTo: currentUser.uid)  // 🔥 PAKAI UID ASLI
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching books: \(error.localizedDescription)")
                    return
                }
                           
         // 💡 PERUBAHAN: Gunakan addSnapshotListener agar layar My Shelf jadi Real-Time!
         shelfListener = db.collection("books")
             .whereField("ownerId", isEqualTo: "currentUser")
             .addSnapshotListener { snapshot, error in
                 if let error = error {
                     print("Error fetching books: \(error.localizedDescription)")
                     return
                 }

                 if let snapshot = snapshot {
                     DispatchQueue.main.async {
                         // Datanya akan otomatis tertimpa dan merender ulang UI tiap kali ada perubahan di Firebase
                         self.shelfBooks = snapshot.documents.compactMap { document -> Book? in
                             let data = document.data()
                             let timestamp = data["dateAdded"] as? Timestamp
                             let date = timestamp?.dateValue() ?? Date()

                             let statusString = data["status"] as? String ?? "Available"
                             let shelfStatus = ShelfStatus(rawValue: statusString) ?? .available

                             return Book(
                                 id: UUID(),
                                 firestoreID: document.documentID,
                                 title: data["title"] as? String ?? "Unknown Title",
                                 author: data["author"] as? String ?? "Unknown Author",
                                 genre: data["genre"] as? String ?? "Unknown",
                                 publisher: data["publisher"] as? String ?? "Unknown",
                                 pageCount: data["pageCount"] as? Int ?? 0,
                                 quote: data["quote"] as? String ?? "",
                                 coverUrl: data["coverUrl"] as? String,
                                 isAvailable: data["isAvailable"] as? Bool ?? true,
                                 ownerId: data["ownerId"] as? String ?? "currentUser",
                                 status: shelfStatus, // Ini sekarang akan otomatis membaca "Swapped"
                                 dateAdded: date
                             )
                         }
                     }
                 }
             }
     }
    
    // MASUKKAN FUNGSI INI DI DALAM CLASS MyShelfViewModel (di bagian paling bawah)
    func updateBook(bookId: UUID, newTitle: String, newAuthor: String, newGenre: String, newPublisher: String, newPageCount: Int, newQuote: String) {
        
        // 1. Cari buku berdasarkan UUID lokal
        if let index = self.shelfBooks.firstIndex(where: { $0.id == bookId }) {
            
            // 2. Update data lokal (Optimistic UI)
            self.shelfBooks[index].title = newTitle
            self.shelfBooks[index].author = newAuthor
            self.shelfBooks[index].genre = newGenre
            self.shelfBooks[index].publisher = newPublisher
            self.shelfBooks[index].pageCount = newPageCount
            self.shelfBooks[index].quote = newQuote
           
            // 3. Update ke database MENGGUNAKAN firestoreID
            if let firestoreID = self.shelfBooks[index].firestoreID, !firestoreID.isEmpty {
                db.collection("books").document(firestoreID).updateData([
                    "title": newTitle,
                    "author": newAuthor,
                    "genre": newGenre,
                    "publisher": newPublisher,
                    "pageCount": newPageCount,
                    "quote": newQuote
                ]) { error in
                    if let error = error {
                        print("❌ Gagal update buku di Firebase: \(error.localizedDescription)")
                    } else {
                        print("✅ Buku berhasil diupdate di Firebase!")
                    }
                }
            } else {
                print("⚠️ Buku ini belum tersinkronisasi dengan Firestore (firestoreID kosong).")
            }
        }
    }
    
}
