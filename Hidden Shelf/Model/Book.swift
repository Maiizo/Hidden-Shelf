//
//  Book.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import Foundation

struct Book: Identifiable, Codable {
    var id = UUID()
    let title: String
    let author: String
    let genre: String
    let quote: String
    let coverUrl: String?
    var status: ShelfStatus
}

// OpenLibrary API Mapping Models
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
    
    var firstAuthor: String {
        author_name?.first ?? "Unknown Author"
    }
    
    var firstGenre: String {
        subject?.first ?? "Fiction"
    }
    
    var formattedCoverUrl: String? {
        if let coverId = cover_i {
            return "https://covers.openlibrary.org/b/id/\(coverId)-M.jpg"
        }
        return nil
    }
}
