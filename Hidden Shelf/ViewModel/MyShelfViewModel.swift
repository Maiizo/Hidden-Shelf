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
    
    // Filter Configuration Engine Bindings
    @Published var selectedGenreFilter: String = "All"
    @Published var selectedAuthorFilter: String = "All"
    @Published var selectedPublisherFilter: String = "All"
    @Published var selectedPageFilter: PageRangeOption = .all
    @Published var selectedSortOption: SortOption = .newest
    
    @Published var apiSearchQuery: String = ""
    @Published var apiResults: [OpenLibraryDoc] = []
    @Published var isSearchingAPI: Bool = false
    
    private let apiService = OpenLibraryService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $apiSearchQuery
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
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
    
    // Dynamic Filter Option Lists Generated Directly from Shelf Inventory Content
    var uniqueGenres: [String] {
        ["All"] + Array(Set(shelfBooks.map { $0.genre })).sorted()
    }
    
    var uniqueAuthors: [String] {
        ["All"] + Array(Set(shelfBooks.map { $0.author })).sorted()
    }
    
    var uniquePublishers: [String] {
        ["All"] + Array(Set(shelfBooks.map { $0.publisher })).sorted()
    }
    
    // Dynamic Evaluated Book Array Filter and Sort Query Engine Output
    var filteredBooks: [Book] {
        var items = shelfBooks.filter { $0.status == activeTab }
        
        // 1. Text Field Category Matching Filter Evaluators
        if selectedGenreFilter != "All" {
            items = items.filter { $0.genre == selectedGenreFilter }
        }
        if selectedAuthorFilter != "All" {
            items = items.filter { $0.author == selectedAuthorFilter }
        }
        if selectedPublisherFilter != "All" {
            items = items.filter { $0.publisher == selectedPublisherFilter }
        }
        
        // 2. Numerical Range Matching Evaluation (Halaman)
        switch selectedPageFilter {
        case .all: break
        case .short: items = items.filter { $0.pageCount < 150 }
        case .medium: items = items.filter { $0.pageCount >= 150 && $0.pageCount <= 400 }
        case .long: items = items.filter { $0.pageCount > 400 }
        }
        
        // 3. Sequential Sorting Engine Output Selection
        switch selectedSortOption {
        case .newest:
            return items.sorted { $0.dateAdded > $1.dateAdded }
        case .alphabetical:
            return items.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        }
    }
    
    func triggerBookSearch(query: String) async {
        isSearchingAPI = true
        do {
            self.apiResults = try await apiService.searchBooks(query: query)
        } catch {
            print("API Query Error: \(error.localizedDescription)")
            self.apiResults = []
        }
        isSearchingAPI = false
    }
    
    func addNewBookToShelf(title: String, author: String, genre: String, publisher: String, pageCount: Int, quote: String, coverUrl: String?) {
        let cleanBook = Book(
            title: title,
            author: author,
            genre: genre,
            publisher: publisher.isEmpty ? "Unknown Publisher" : publisher,
            pageCount: pageCount,
            quote: quote.isEmpty ? "Mystery book entry." : quote,
            coverUrl: coverUrl,
            status: .available,
            dateAdded: Date() // Save initialization time stamp
        )
        shelfBooks.append(cleanBook)
    }
}
