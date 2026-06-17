//
//  MyShelfViewModelTests.swift
//  Hidden ShelfTests
//
//  Created by student on 04/06/26.
//


import XCTest
@testable import Hidden_Shelf

@MainActor
final class MyShelfViewModelTests: XCTestCase {
    
    var viewModel: MyShelfViewModel!

    override func setUpWithError() throws {
        // Dijalankan SEBELUM setiap test dimulai
        viewModel = MyShelfViewModel()
        // Pastikan rak mulai dalam keadaan kosong untuk testing
        viewModel.shelfBooks = []
        // Baris viewModel.filteredBooks = [] dihapus karena ia adalah computed property
    }

    override func tearDownWithError() throws {
        // Dijalankan SETELAH setiap test selesai
        viewModel = nil
    }

    // MARK: - 1. Test Create (Tambah Buku)
    func testAddNewBookToShelf() throws {
        // Arrange
        XCTAssertTrue(viewModel.shelfBooks.isEmpty, "Rak buku harusnya kosong di awal")
        
        // Act
        viewModel.addNewBookToShelf(
            title: "Buku Misteri Pertama",
            author: "Tere Liye",
            genre: "Fiction",
            publisher: "Gramedia",
            pageCount: 350,
            quote: "Sangat inspiratif",
            coverUrl: nil
        )
        
        // Assert
        XCTAssertEqual(viewModel.shelfBooks.count, 1, "Jumlah buku di rak harusnya bertambah jadi 1")
        XCTAssertEqual(viewModel.shelfBooks.first?.title, "Buku Misteri Pertama", "Judul buku tidak sesuai dengan input")
        XCTAssertEqual(viewModel.shelfBooks.first?.status, .available, "Status buku baru harus default ke 'available'")
    }
    
    // MARK: - 2. Test Update (Edit Buku)
    func testUpdateBookInfo() throws {
        // Arrange: Tambahkan 1 buku dulu
        viewModel.addNewBookToShelf(
            title: "Buku Lama",
            author: "Penulis Lama",
            genre: "Horror",
            publisher: "Penerbit Lama",
            pageCount: 100,
            quote: "Biasa saja",
            coverUrl: nil
        )
        
        guard let bookToEdit = viewModel.shelfBooks.first else {
            XCTFail("Gagal menyiapkan data buku untuk dites")
            return
        }
        
        // Act: Edit buku tersebut menggunakan UUID-nya
        viewModel.updateBook(
            bookId: bookToEdit.id,
            newTitle: "Judul Baru Edit",
            newAuthor: "Penulis Baru",
            newGenre: "Comedy",
            newPublisher: "Penerbit Baru",
            newPageCount: 250,
            newQuote: "Ternyata lucu"
        )
        
        // Assert: Pastikan datanya berubah
        let updatedBook = viewModel.shelfBooks.first(where: { $0.id == bookToEdit.id })
        XCTAssertEqual(updatedBook?.title, "Judul Baru Edit", "Fungsi update gagal mengubah judul")
        XCTAssertEqual(updatedBook?.genre, "Comedy", "Fungsi update gagal mengubah genre")
        XCTAssertEqual(updatedBook?.pageCount, 250, "Fungsi update gagal mengubah jumlah halaman")
    }
    
    // MARK: - 3. Test Logika Filter
    func testFilterLogic() throws {
        // Arrange: Tambahkan beberapa buku dengan genre berbeda
        viewModel.addNewBookToShelf(title: "A", author: "X", genre: "Fiction", publisher: "P", pageCount: 100, quote: "-", coverUrl: nil)
        viewModel.addNewBookToShelf(title: "B", author: "Y", genre: "Sci-Fi", publisher: "P", pageCount: 100, quote: "-", coverUrl: nil)
        viewModel.addNewBookToShelf(title: "C", author: "Z", genre: "Fiction", publisher: "P", pageCount: 100, quote: "-", coverUrl: nil)
        
        // Act: Terapkan filter khusus genre Fiction
        viewModel.selectedGenreFilter = "Fiction"
        // Baris viewModel.applyFilters() dihapus, langsung simpan hasilnya ke variabel
        let result = viewModel.filteredBooks
        
        // Assert
        XCTAssertEqual(result.count, 2, "Hanya 2 buku bergenre Fiction yang seharusnya tersaring")
        XCTAssertTrue(result.allSatisfy { $0.genre == "Fiction" }, "Semua buku di hasil filter harus bergenre Fiction")
    }
}
