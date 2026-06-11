//
//  DiscoveryViewModel.swift
//  Hidden Shelf
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

class DiscoveryViewModel: ObservableObject {
    @Published var allBooks: [Book] = []
    @Published var filteredBooks: [Book] = []
    @Published var isLoading = false
    
    @Published var selectedGenre: String = "All Genres"
    @Published var selectedPageCountRange: String = "Any Page Count"
    @Published var selectedCity: String = "All Cities"
    
    let genres = ["All Genres", "Philosophy", "Classic", "Fiction", "Romance", "Sci-Fi"]
    let pageRanges = ["Any Page Count", "Short (< 150 pgs)", "Medium (150 - 300 pgs)", "Long (> 300 pgs)"]
    let cities = ["All Cities", "Surabaya", "Jakarta", "Bandung", "Malang"]
    
    private var db = Firestore.firestore()
    private var currentUserId: String {
        Auth.auth().currentUser?.uid ?? ""
    }

    func loadBooks() {
        guard let currentUser = Auth.auth().currentUser else {
            print("❌ USER TIDAK LOGIN!")
            return
        }
        
        // Capture the uid immediately so it's available in all nested closures
        let currentUID = currentUser.uid
        
        print("📱 User login UID: \(currentUID)")
        print("📱 User email: \(currentUser.email ?? "unknown")")
        
        isLoading = true
        
        db.collection("books").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error: \(error)")
                return
            }
            
            guard let allDocs = snapshot?.documents else {
                print("⚠️ FIRESTORE KOSONG!")
                return
            }
   
            
            let eligibleBooks = allDocs.filter { doc in
                let data = doc.data()
                let ownerId = data["ownerId"] as? String ?? ""
                let isAvailable = data["isAvailable"] as? Bool ?? false
                return (ownerId != currentUID) && isAvailable  // ← use currentUID
            }
            
            DispatchQueue.main.async {
                self.allBooks = eligibleBooks.compactMap { doc -> Book? in
                    let data = doc.data()
                    let timestamp = data["dateAdded"] as? Timestamp
                    let date = timestamp?.dateValue() ?? Date()
                    let statusString = data["status"] as? String ?? "Available"
                    let shelfStatus = ShelfStatus(rawValue: statusString) ?? .available
                    
                    return Book(
                        id: UUID(),
                        firestoreID: doc.documentID,
                        title: data["title"] as? String ?? "Unknown Title",
                        author: data["author"] as? String ?? "Unknown Author",
                        genre: data["genre"] as? String ?? "Unknown",
                        publisher: data["publisher"] as? String ?? "Unknown",
                        pageCount: data["pageCount"] as? Int ?? 0,
                        quote: data["quote"] as? String ?? "",
                        coverUrl: data["coverUrl"] as? String,
                        isAvailable: data["isAvailable"] as? Bool ?? true,
                        ownerId: data["ownerId"] as? String ?? "",
                        status: shelfStatus,
                        dateAdded: date
                    )
                }
                self.isLoading = false
                self.applyFilters()
            }
        }
    }
    
    func applyFilters() {
        print("\n----- APPLY FILTERS -----")
        print("Sebelum filter: \(allBooks.count) buku")
        
        filteredBooks = allBooks.filter { book in
            let matchGenre = selectedGenre == "All Genres" || book.genre.lowercased() == selectedGenre.lowercased()
            let matchCity = true // Belum implementasi city
            
            let matchPages: Bool
            switch selectedPageCountRange {
            case "Short (< 150 pgs)":
                matchPages = book.pageCount < 150
            case "Medium (150 - 300 pgs)":
                matchPages = book.pageCount >= 150 && book.pageCount <= 300
            case "Long (> 300 pgs)":
                matchPages = book.pageCount > 300
            default:
                matchPages = true
            }
            
            return matchGenre && matchCity && matchPages
        }
        
        print("Setelah filter: \(filteredBooks.count) buku")
        if filteredBooks.isEmpty {
            print("⚠️⚠️⚠️ TIDAK ADA BUKU YANG LOLOS FILTER! ⚠️⚠️⚠️")
        } else {
            for book in filteredBooks {
                print("   📖 \(book.title) - \(book.genre) - \(book.pageCount) halaman")
            }
        }
        print("------------------------\n")
    }
    
    // Membuat dokumen Match baru di Firebase
    func requestSwap(for book: Book, completion: @escaping (String) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
               print("Error: no user logged in")
               return
           }
        let matchRef = db.collection("matches").document() // Bikin ID acak baru
        
        let matchData: [String: Any] = [
            "bookId": book.firestoreID ?? "",
            "requesterId": currentUser.uid, 
            "ownerId": book.ownerId,
            "requesterStatus": 0,
            "ownerStatus": 0,
            "latitude": -7.2856, // Opsional: Koordinat UC Surabaya
            "longitude": 112.6315
        ]
        
        matchRef.setData(matchData) { error in
            if let error = error {
                print("Gagal membuat request swap: \(error.localizedDescription)")
            } else {
                // Kembalikan ID Match yang baru terbuat ke View
                completion(matchRef.documentID)
            }
        }
    }
    
}
