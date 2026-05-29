//
//  Book.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import Foundation

struct Book: Identifiable, Codable {
    var id: String = UUID().uuidString
    let title: String
    let author: String
    let genre: String
    let publisher: String    // Added: Penerbit
    let pageCount: Int       // Added: Jumlah Halaman
    let quote: String
    let coverUrl: String?
    var status: ShelfStatus
    let dateAdded: Date      // Added: Track system creation timestamp for sorting
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
