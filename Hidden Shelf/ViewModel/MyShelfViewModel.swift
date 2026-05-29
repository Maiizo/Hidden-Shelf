//
//  MyShelfViewModel.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import Foundation
import Combine

@MainActor
class MyShelfViewModel: ObservableObject {
    @Published var activeTab: ShelfStatus = .available
    @Published var viewMode: ViewMode = .card
    
    @Published var shelfBooks: [Book] = []
    
    @Published var apiSearchQuery: String = ""
    @Published var apiResults: [OpenLibraryDoc] = []
    @Published var isSearchingAPI: Bool = false
    
    private let apiService = OpenLibraryService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Automatically fetch from OpenLibrary API when user types, with a 500ms safety debounce
        $apiSearchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                if query.count > 2 {
                    Task { await self.triggerBookSearch(query: query) }
                } else {
                    self.apiResults = []
                }
            }
            .store(in: &cancellables)
    }
    
    var filteredBooks: [Book] {
        shelfBooks.filter { $0.status == activeTab }
    }
    
    func triggerBookSearch(query: String) async {
        isSearchingAPI = true
        do {
            self.apiResults = try await apiService.searchBooks(query: query)
        } catch {
            print("API Search Failed: \(error.localizedDescription)")
            self.apiResults = []
        }
        isSearchingAPI = false
    }
    
    func addNewBookToShelf(title: String, author: String, genre: String, quote: String, coverUrl: String?) {
        let cleanBook = Book(
            title: title,
            author: author,
            genre: genre,
            quote: quote.isEmpty ? "Mystery book entry." : quote,
            coverUrl: coverUrl,
            status: .available
        )
        shelfBooks.append(cleanBook)
    }
}
