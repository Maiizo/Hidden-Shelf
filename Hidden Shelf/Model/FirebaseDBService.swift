//
//  FirebaseDBService.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import Foundation
import FirebaseFirestore

class FirebaseDBService {
    static let shared = FirebaseDBService()
    private let db = Firestore.firestore()
    
    // Mengambil buku yang statusnya available
    func fetchAvailableBooks(completion: @escaping ([Book]?, Error?) -> Void) {
        db.collection("books").whereField("isAvailable", isEqualTo: true).getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion([], nil)
                return
            }
            
            // Mapping dokumen Firestore ke model Book secara manual dan aman
            let books = documents.compactMap { doc -> Book? in
                let data = doc.data()
                
                // Konversi Timestamp Firestore ke Swift Date
                let timestamp = data["dateAdded"] as? Timestamp
                let date = timestamp?.dateValue() ?? Date()
                
                // Konversi status string ke enum ShelfStatus
                let statusString = data["status"] as? String ?? "Available"
                let shelfStatus = ShelfStatus(rawValue: statusString) ?? .available
                
                return Book(
                    id: UUID(), // ID lokal unik untuk list SwiftUI
                    firestoreID: doc.documentID, // Simpan ID dokumen asli Firestore
                    title: data["title"] as? String ?? "Unknown Title",
                    author: data["author"] as? String ?? "Unknown Author",
                    genre: data["genre"] as? String ?? "Unknown",
                    publisher: data["publisher"] as? String ?? "Unknown",
                    pageCount: data["pageCount"] as? Int ?? 0,
                    quote: data["quote"] as? String ?? "Mystery book entry.",
                    coverUrl: data["coverUrl"] as? String,
                    isAvailable: data["isAvailable"] as? Bool ?? true,
                    ownerId: data["ownerId"] as? String ?? "Unknown",
                    status: shelfStatus,
                    dateAdded: date
                )
            }
            completion(books, nil)
        }
    }
}
