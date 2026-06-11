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
    
    func loadBooks() {
        print("\n🔥🔥🔥 LOAD BOOKS DISCOVER 🔥🔥🔥")
        
        // CEK USER LOGIN
        guard let currentUser = Auth.auth().currentUser else {
            print("❌ USER TIDAK LOGIN!")
            return
        }
        
        print("📱 User login UID: \(currentUser.uid)")
        print("📱 User email: \(currentUser.email ?? "unknown")")
        
        isLoading = true
        
        // 🔥 CEK SEMUA BUKU DULU (TANPA FILTER APAPUN)
        print("\n----- CEK SEMUA BUKU DI FIRESTORE (NO FILTER) -----")
        db.collection("books").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error: \(error)")
                return
            }
            
            guard let allDocs = snapshot?.documents else {
                print("⚠️ FIRESTORE KOSONG! Tidak ada buku sama sekali.")
                return
            }
            
            print("📊 TOTAL BUKU DI FIRESTORE: \(allDocs.count)")
            
            for (index, doc) in allDocs.enumerated() {
                let data = doc.data()
                let ownerId = data["ownerId"] as? String ?? "NO_OWNER_ID"
                let isAvail = data["isAvailable"] as? Bool ?? false
                let title = data["title"] as? String ?? "NO_TITLE"
                let isSelf = (ownerId == currentUser.uid) ? "⭐ MILIK SENDIRI" : "👤 MILIK ORANG LAIN"
                
                print("\(index+1). [\(doc.documentID)]")
                print("   Title: \(title)")
                print("   ownerId: \(ownerId)")
                print("   isAvailable: \(isAvail)")
                print("   Status: \(isSelf)")
                print("   ---")
            }
            
            // 🔥 HITUNG MANUAL BUKU YANG LAYAK TAMPIL
            print("\n----- FILTER MANUAL DI KODE -----")
            let eligibleBooks = allDocs.filter { doc in
                let data = doc.data()
                let ownerId = data["ownerId"] as? String ?? ""
                let isAvailable = data["isAvailable"] as? Bool ?? false
                
                let isNotSelf = (ownerId != currentUser.uid)
                let isAvailableTrue = (isAvailable == true)
                
                return isNotSelf && isAvailableTrue
            }
            
            print("📊 Buku yang layak tampil (bukan milik sendiri & available): \(eligibleBooks.count)")
            
            for doc in eligibleBooks {
                let data = doc.data()
                print("   ✅ LAYAK: \(data["title"] ?? "?") | ownerId: \(data["ownerId"] ?? "?")")
            }
            
            // 🔥 UPDATE UI
            DispatchQueue.main.async {
                self.allBooks = eligibleBooks.compactMap { doc -> Book? in
                    let data = doc.data()
                    let timestamp = data["dateAdded"] as? Timestamp
                    let date = timestamp?.dateValue() ?? Date()
                    let statusString = data["status"] as? String ?? "Available"
                    let shelfStatus = ShelfStatus(rawValue: statusString) ?? .available
                    let ownerId = data["ownerId"] as? String ?? ""
                    
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
                        ownerId: ownerId,
                        status: shelfStatus,
                        dateAdded: date
                    )
                }
                self.isLoading = false
                self.applyFilters()
                print("📊 allBooks count setelah mapping: \(self.allBooks.count)")
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
}
