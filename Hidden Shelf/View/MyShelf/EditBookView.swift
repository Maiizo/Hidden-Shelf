//
//  EditBookView.swift
//  Hidden Shelf
//
//  Created by student on 04/06/26.
//

import SwiftUI

struct EditBookView: View {
    // Menggunakan dismiss modern yang anti-error
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: MyShelfViewModel
    
    var book: Book
    
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var genre: String = ""
    @State private var publisher: String = ""
    @State private var pageCount: String = ""
    @State private var quote: String = ""
    
    init(viewModel: MyShelfViewModel, book: Book) {
        self.viewModel = viewModel
        self.book = book
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Informasi Buku").foregroundColor(Theme.carob)) {
                    TextField("Judul Buku", text: $title)
                    TextField("Penulis", text: $author)
                    TextField("Penerbit", text: $publisher)
                    TextField("Genre", text: $genre)
                    TextField("Jumlah Halaman", text: $pageCount)
                        .keyboardType(.numberPad)
                }
                .listRowBackground(Theme.vanilla)
                
                Section(header: Text("Daya Tarik / Pesan Rahasia").foregroundColor(Theme.carob)) {
                    TextEditor(text: $quote)
                        .frame(height: 100)
                }
                .listRowBackground(Theme.vanilla)
            }
            .scrollContentBackground(.hidden)
            .background(Theme.almond.ignoresSafeArea())
            .navigationTitle("Edit Buku")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Batal") {
                        dismiss() // Penulisan yang benar
                    }
                    .foregroundColor(Theme.carob)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Simpan") {
                        saveChanges()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(Theme.matcha)
                }
            }
            .onAppear {
                self.title = book.title
                self.author = book.author
                self.genre = book.genre
                self.publisher = book.publisher
                self.pageCount = "\(book.pageCount)"
                self.quote = book.quote
            }
        }
    }
    
    private func saveChanges() {
        viewModel.updateBook(
            bookId: book.id,
            newTitle: title,
            newAuthor: author,
            newGenre: genre,
            newPublisher: publisher,
            newPageCount: Int(pageCount) ?? 0,
            newQuote: quote
        )
        dismiss()
    }
}

//
//#Preview {
//    EditBookView()
//}
