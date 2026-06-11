//
//  DiscoveryViewModel.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import Foundation
import Combine
import FirebaseFirestore

class DiscoveryViewModel: ObservableObject {
    @Published var allBooks: [Book] = []
    @Published var filteredBooks: [Book] = []
    
    // State Filter sesuai Gambar mockup
    @Published var selectedGenre: String = "All Genres"
    @Published var selectedPageCountRange: String = "Any Page Count"
    @Published var selectedCity: String = "All Cities"
    
    // Opsi pilihan filter
    let genres = ["All Genres", "Philosophy", "Classic", "Fiction", "Romance", "Sci-Fi"]
    let pageRanges = ["Any Page Count", "Short (< 150 pgs)", "Medium (150 - 300 pgs)", "Long (> 300 pgs)"]
    let cities = ["All Cities", "Surabaya", "Jakarta", "Bandung", "Malang"]
    
    private var db = Firestore.firestore()
    
    // FIXED: Mengambil data langsung dari Firestore tanpa melalui FirebaseDBService
    func loadBooks() {
        db.collection("books")
            .whereField("isAvailable", isEqualTo: true)
            .whereField("ownerId", isNotEqualTo: "currentUser") // Filter agar buku sendiri tidak muncul di Discovery
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error loading discovery books: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                DispatchQueue.main.async {
                    self?.allBooks = documents.compactMap { doc -> Book? in
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
                            ownerId: data["ownerId"] as? String ?? "currentUser",
                            status: shelfStatus,
                            dateAdded: date
                        )
                    }
                    // Jalankan filter setelah data berhasil dimuat
                    self?.applyFilters()
                }
            }
    }
    
    func applyFilters() {
        filteredBooks = allBooks.filter { book in
            // 1. Filter Genre
            let matchGenre = selectedGenre == "All Genres" || book.genre.lowercased() == selectedGenre.lowercased()
            
            // 2. Filter City (Bypass true dulu karena properti city sudah dihapus dari objek Book)
            let matchCity = true
            
            // 3. Filter Page Count
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
    }
    
    // Membuat dokumen Match baru di Firebase
    func requestSwap(for book: Book, completion: @escaping (String) -> Void) {
        let matchRef = db.collection("matches").document() // Bikin ID acak baru
        
        let matchData: [String: Any] = [
            "bookId": book.firestoreID ?? "",
            "requesterId": "currentUser", // Nanti pakai ID asli
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
