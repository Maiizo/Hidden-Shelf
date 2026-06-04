//
//  Book.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import Foundation

struct Book: Identifiable, Codable {
    // ID lokal dibiarkan 'let' karena identitas asli buku tidak boleh berubah
    let id: UUID
    
    // Atribut ini diubah menjadi 'var' agar bisa ditimpa saat fitur Edit disimpan
    var firestoreID: String?
    var title: String
    var author: String
    var genre: String
    var publisher: String
    var pageCount: Int
    var quote: String
    var coverUrl: String?
    var isAvailable: Bool
    var ownerId: String
    var status: ShelfStatus
    var dateAdded: Date
    
    // Computed property city dikembalikan agar filter dan UI kamu tidak error
    var city: String {
        // Simulasi kota berbeda berdasarkan ownerId untuk testing filter:
        if ownerId == "user_jakarta" {
            return "Jakarta"
        } else if ownerId == "user_bandung" {
            return "Bandung"
        } else if ownerId == "user_malang" {
            return "Malang"
        } else {
            return "Surabaya" // Default fallback
        }
    }
}

struct OpenLibraryResponse: Codable {
    let docs: [OpenLibraryDoc]
}

struct OpenLibraryDoc: Codable, Identifiable {
    var id: String { key }
    let key: String
    let title: String
    let author_name: [String]?
    let cover_i: Int?
    let subject: [String]?
    let publisher: [String]?                  // Added: Map network array strings
    let number_of_pages_median: Int?          // Added: Map network median integer page layout
    
    var firstAuthor: String {
        author_name?.first ?? "Unknown Author"
    }
    
    var firstGenre: String {
        subject?.first ?? "General"
    }
    
    var firstPublisher: String {
        publisher?.first ?? "Unknown Publisher"
    }
    
    var totalPages: Int {
        number_of_pages_median ?? 0
    }
    
    var formattedCoverUrl: String? {
        if let coverId = cover_i {
            return "https://covers.openlibrary.org/b/id/\(coverId)-M.jpg"
        }
        return nil
    }
}

extension Book {
    // Kumpulan dummy data untuk keperluan Testing UI tanpa Firebase
    static let dummyBooks: [Book] = [
        Book(id: UUID(), firestoreID: "dummy_1", title: "Misteri 1", author: "Penulis A", genre: "Fiction", publisher: "Penerbit X", pageCount: 200, quote: "Sebuah rahasia besar tersimpan di balik pintu itu...", coverUrl: nil, isAvailable: true, ownerId: "user_1", status: .available, dateAdded: Date()),
        
        Book(id: UUID(), firestoreID: "dummy_2", title: "Misteri 2", author: "Penulis B", genre: "Philosophy", publisher: "Penerbit Y", pageCount: 120, quote: "Hanya mereka yang berani melihat ke dalam diri sendiri yang akan menemukan kedamaian.", coverUrl: nil, isAvailable: true, ownerId: "user_2", status: .available, dateAdded: Date()),
        
        Book(id: UUID(), firestoreID: "dummy_3", title: "Misteri 3", author: "Penulis C", genre: "Sci-Fi", publisher: "Penerbit Z", pageCount: 350, quote: "Bintang-bintang tidak pernah salah, kitalah yang salah membacanya.", coverUrl: nil, isAvailable: true, ownerId: "user_3", status: .available, dateAdded: Date())
    ]
}
