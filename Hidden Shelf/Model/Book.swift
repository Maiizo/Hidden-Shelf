//
//  Book.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import Foundation

struct Book: Identifiable, Codable {
    var id = UUID()          // Kembali menggunakan UUID sesuai kebutuhan tim
    var firestoreID: String?
    let title: String
    let author: String
    let genre: String
    let publisher: String    // Added: Penerbit
    let pageCount: Int       // Added: Jumlah Halaman
    let quote: String
    let coverUrl: String?
    var isAvailable: Bool
    var ownerId: String
    var status: ShelfStatus
    let dateAdded: Date      // Added: Track system creation timestamp for sorting
    
    // PENYANGGA SEMENTARA:
    // Menghubungkan filter pencarian kota dengan data default/mock.
    // Nanti teman Anda bisa menghubungkannya dengan profil pemilik asli berdasarkan `ownerId`.
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
