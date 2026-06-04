//
//  DiscoveryFeatureTests.swift
//  Hidden Shelf
//
//  Created by student on 04/06/26.
//

import XCTest
import Foundation
@testable import Hidden_Shelf // ⚠️ Pastikan nama target aplikasi kamu sudah benar

final class DiscoveryFeatureTests: XCTestCase {
    
    var viewModel: DiscoveryViewModel!
    
    // Dipanggil otomatis sebelum test case dimulai
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = DiscoveryViewModel()
    }

    // Dipanggil otomatis setelah test case selesai
    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }
    
    // MARK: - HELPER FACTORY
    private func createDummyBook(title: String, genre: String, pageCount: Int) -> Book {
        return Book(
            id: UUID(),
            firestoreID: "mock_id_\(title.replacingOccurrences(of: " ", with: "_"))",
            title: title,
            author: "Test Author",
            genre: genre,
            publisher: "Test Publisher",
            pageCount: pageCount,
            quote: "This is a placeholder quote.",
            coverUrl: nil,
            isAvailable: true,
            ownerId: "someone_else",
            status: .available,
            dateAdded: Date()
        )
    }
    
    // MARK: - TEST CASES Fitur Discovery & Filter Sheet

    func testApplyFilters_withDefaultOptions_shouldReturnAllBooks() {
        // Given (Kondisi Awal)
        let book1 = createDummyBook(title: "Beyond Good and Evil", genre: "Philosophy", pageCount: 120)
        let book2 = createDummyBook(title: "The Great Gatsby", genre: "Classic", pageCount: 180)
        let book3 = createDummyBook(title: "Dune", genre: "Sci-Fi", pageCount: 450)
        
        viewModel.allBooks = [book1, book2, book3]
        viewModel.selectedGenre = "All Genres"
        viewModel.selectedPageCountRange = "Any Page Count"
        viewModel.selectedCity = "All Cities"
        
        // When (Aksi)
        // 💡 FIXED: Diubah ke applyFilters() agar menguji logic filter internal secara sinkronus
        viewModel.applyFilters()
        
        // Then (Validasi)
        XCTAssertEqual(viewModel.filteredBooks.count, 3, "Harusnya semua buku lolos jika menggunakan filter default.")
    }
    
    func testApplyFilters_withSpecificGenre_shouldFilterAccurately() {
        // Given
        let bookPhil = createDummyBook(title: "Meditations", genre: "Philosophy", pageCount: 140)
        let bookRom = createDummyBook(title: "Pride and Prejudice", genre: "Romance", pageCount: 250)
        
        viewModel.allBooks = [bookPhil, bookRom]
        viewModel.selectedGenre = "Philosophy"
        
        // When
        viewModel.applyFilters()
        
        // Then
        XCTAssertEqual(viewModel.filteredBooks.count, 1, "Hanya boleh ada 1 buku bergenre Philosophy.")
        XCTAssertEqual(viewModel.filteredBooks.first?.title, "Meditations", "Buku yang lolos harusnya adalah Meditations.")
    }
    
    func testApplyFilters_withShortPageCountRange_shouldReturnOnlyShortBooks() {
        // Given
        let shortBook = createDummyBook(title: "Buku Tipis", genre: "Fiction", pageCount: 100)
        let mediumBook = createDummyBook(title: "Buku Sedang", genre: "Fiction", pageCount: 200)
        
        viewModel.allBooks = [shortBook, mediumBook]
        viewModel.selectedPageCountRange = "Short (< 150 pgs)"
        
        // When
        viewModel.applyFilters()
        
        // Then
        XCTAssertEqual(viewModel.filteredBooks.count, 1, "Hanya buku di bawah 150 halaman yang lolos.")
        XCTAssertEqual(viewModel.filteredBooks.first?.title, "Buku Tipis")
    }
    
    func testApplyFilters_withMediumPageCountRange_shouldReturnOnlyMediumBooks() {
        // Given
        let shortBook = createDummyBook(title: "Buku Tipis", genre: "Fiction", pageCount: 149)
        let mediumBook = createDummyBook(title: "Buku Sedang", genre: "Fiction", pageCount: 150)
        let longBook = createDummyBook(title: "Buku Tebal", genre: "Fiction", pageCount: 301)
        
        viewModel.allBooks = [shortBook, mediumBook, longBook]
        viewModel.selectedPageCountRange = "Medium (150 - 300 pgs)"
        
        // When
        viewModel.applyFilters()
        
        // Then
        XCTAssertEqual(viewModel.filteredBooks.count, 1)
        XCTAssertEqual(viewModel.filteredBooks.first?.title, "Buku Sedang")
    }
    
    func testApplyFilters_withLongPageCountRange_shouldReturnOnlyLongBooks() {
        // Given
        let mediumBook = createDummyBook(title: "Buku Sedang", genre: "Fiction", pageCount: 300)
        let longBook = createDummyBook(title: "Buku Tebal", genre: "Fiction", pageCount: 600)
        
        viewModel.allBooks = [mediumBook, longBook]
        viewModel.selectedPageCountRange = "Long (> 300 pgs)"
        
        // When
        viewModel.applyFilters()
        
        // Then
        XCTAssertEqual(viewModel.filteredBooks.count, 1)
        XCTAssertEqual(viewModel.filteredBooks.first?.title, "Buku Tebal")
    }
    
    func testApplyFilters_withCombinedCriteria_shouldFilterStrictly() {
        // Given
        let targetBook = createDummyBook(title: "The Republic", genre: "Philosophy", pageCount: 280)
        let wrongGenre = createDummyBook(title: "Neuromancer", genre: "Sci-Fi", pageCount: 270)
        let wrongPages = createDummyBook(title: "Critique of Pure Reason", genre: "Philosophy", pageCount: 800)
        
        viewModel.allBooks = [targetBook, wrongGenre, wrongPages]
        viewModel.selectedGenre = "Philosophy"
        viewModel.selectedPageCountRange = "Medium (150 - 300 pgs)"
        
        // When
        viewModel.applyFilters()
        
        // Then
        XCTAssertEqual(viewModel.filteredBooks.count, 1, "Hanya 1 buku yang memenuhi kedua kriteria sekaligus.")
        XCTAssertEqual(viewModel.filteredBooks.first?.title, "The Republic")
    }

    func testApplyFilters_withSpecificCity_shouldStillReturnAllBooksDueToBypass() {
        // Given
        let book1 = createDummyBook(title: "Surabaya History", genre: "History", pageCount: 160)
        let book2 = createDummyBook(title: "Jakarta Lights", genre: "Fiction", pageCount: 210)
        
        viewModel.allBooks = [book1, book2]
        viewModel.selectedCity = "Surabaya"
        
        // When
        viewModel.applyFilters()
        
        // Then
        XCTAssertEqual(viewModel.filteredBooks.count, 2, "Harusnya semua lolos karena filter kota di-bypass true di dalam ViewModel.")
    }
    
    func testInitialState_shouldBeEmpty() {
        // Then
        XCTAssertTrue(viewModel.allBooks.isEmpty)
        XCTAssertTrue(viewModel.filteredBooks.isEmpty)
        XCTAssertEqual(viewModel.selectedGenre, "All Genres")
        XCTAssertEqual(viewModel.selectedPageCountRange, "Any Page Count")
        XCTAssertEqual(viewModel.selectedCity, "All Cities")
    }
}
