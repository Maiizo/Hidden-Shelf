//
//  DiscoveryViewModel.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import Foundation
import Combine

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
    
    func loadBooks() {
        FirebaseDBService.shared.fetchAvailableBooks { [weak self] fetchedBooks, error in
            if let fetchedBooks = fetchedBooks {
                DispatchQueue.main.async {
                    self?.allBooks = fetchedBooks
                    self?.applyFilters()
                }
            }
        }
    }
    
    func applyFilters() {
        filteredBooks = allBooks.filter { book in
            // 1. Filter Genre
            let matchGenre = selectedGenre == "All Genres" || book.genre.lowercased() == selectedGenre.lowercased()
            
            // 2. Filter City
            let matchCity = selectedCity == "All Cities" || book.city.lowercased() == selectedCity.lowercased()
            
            // 3. Filter Page Count
            let matchPages: Bool
            switch selectedPageCountRange {
            case "Short (< 150 pgs)":
                matchPages = book.pages < 150
            case "Medium (150 - 300 pgs)":
                matchPages = book.pages >= 150 && book.pages <= 300
            case "Long (> 300 pgs)":
                matchPages = book.pages > 300
            default:
                matchPages = true
            }
            
            return matchGenre && matchCity && matchPages
        }
    }
}
