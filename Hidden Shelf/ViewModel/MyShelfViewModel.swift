//
//  MyShelfViewModel.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//
import Foundation
import Combine
import FirebaseFirestore

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
                
            // ADD THIS LINE HERE: Fetch books immediately when the page loads
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
    
    func addNewBookToShelf(title: String, author: String, genre: String, publisher: String, pageCount: Int, quote: String, coverUrl: String?) {
            
            // 1. Package the data for Firebase
            let bookData: [String: Any] = [
                "title": title,
                "author": author,
                "genre": genre,
                "publisher": publisher.isEmpty ? "Unknown Publisher" : publisher,
                "pageCount": pageCount,
                "quote": quote.isEmpty ? "Mystery book entry." : quote,
                "coverUrl": coverUrl ?? "", // Firebase prefers empty strings over nil
                "status": ShelfStatus.available.rawValue,
                "dateAdded": Timestamp(date: Date()) // Firebase uses its own Timestamp format
            ]
            
            // 2. Send it to the "books" collection in Firestore
            db.collection("books").addDocument(data: bookData) { error in
                if let error = error {
                    print("❌ FIREBASE ERROR: \(error.localizedDescription)")
                } else {
                    print("✅ FIREBASE SUCCESS! Book successfully saved to the database!")
                    
                    // 3. Re-fetch the books from Firebase so your screen updates
                    self.fetchMyBooks()
                }
            }
        }
    
    func fetchMyBooks() {
        // Assume you have a collection called "books" in Firestore
        db.collection("books").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching books: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                // 1. MUST wrap in DispatchQueue to safely update the UI from Firebase
                DispatchQueue.main.async {
                    // 2. FIXED: Changed 'self.books' to 'self.shelfBooks'
                    self.shelfBooks = snapshot.documents.compactMap { document -> Book? in
                        let data = document.data()
                        
                        // Safely parse Firestore Timestamp into Swift Date
                        let timestamp = data["dateAdded"] as? Timestamp
                        let date = timestamp?.dateValue() ?? Date()
                        
                        // Safely parse the status back into your ShelfStatus Enum
                        let statusString = data["status"] as? String ?? "Available"
                        let shelfStatus = ShelfStatus(rawValue: statusString) ?? .available
                        
                        // 3. FIXED: Added all missing properties (quote, status, dateAdded)
                        return Book(
                            id: UUID(), // Creates a new local ID
                            title: data["title"] as? String ?? "Unknown Title",
                            author: data["author"] as? String ?? "Unknown Author",
                            genre: data["genre"] as? String ?? "Unknown",
                            publisher: data["publisher"] as? String ?? "Unknown",
                            pageCount: data["pageCount"] as? Int ?? 0,
                            quote: data["quote"] as? String ?? "",
                            coverUrl: data["coverUrl"] as? String,
                            status: shelfStatus,
                            dateAdded: date
                        )
                    }
                }
            }
        }
    }
}
