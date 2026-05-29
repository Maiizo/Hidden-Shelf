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
            
            // Mapping dokumen Firestore ke model Book secara otomatis via Codable
            let books = snapshot?.documents.compactMap { doc -> Book? in
                do {
                    return try doc.data(as: Book.self)
                } catch {
                    print("Gagal decode buku: \(error.localizedDescription)")
                    return nil
                }
            }
            completion(books, nil)
        }
    }
}
