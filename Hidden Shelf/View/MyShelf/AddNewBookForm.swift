//
//  AddNewBookForm.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import SwiftUI

struct AddNewBookForm: View {
    @ObservedObject var viewModel: MyShelfViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var inputTitle = ""
    @State private var inputAuthor = ""
    @State private var inputGenre = ""
    @State private var inputQuote = ""
    @State private var onlineCoverUrl: String? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appAlmond
                    .ignoresSafeArea()
                
                Form {
                    Section(header: Text("Search Book database").foregroundColor(.appCarob)) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.appCarob)
                            TextField("Type title here to auto-fill...", text: $viewModel.apiSearchQuery)
                                .foregroundColor(.appCarob)
                            if viewModel.isSearchingAPI {
                                ProgressView()
                            }
                        }
                        
                        // Live API lookup display inside form container rows
                        if !viewModel.apiResults.isEmpty {
                            ForEach(viewModel.apiResults) { doc in
                                Button(action: {
                                    inputTitle = doc.title
                                    inputAuthor = doc.firstAuthor
                                    inputGenre = doc.firstGenre
                                    onlineCoverUrl = doc.formattedCoverUrl
                                    viewModel.apiResults = []
                                    viewModel.apiSearchQuery = ""
                                }) {
                                    HStack(spacing: 12) {
                                        if let urlStr = doc.formattedCoverUrl, let url = URL(string: urlStr) {
                                            AsyncImage(url: url) { img in
                                                img.resizable().aspectRatio(contentMode: .fit)
                                            } placeholder: {
                                                Color.appPistache
                                            }
                                            .frame(width: 30, height: 42)
                                            .cornerRadius(4)
                                        }
                                        VStack(alignment: .leading) {
                                            Text(doc.title)
                                                .font(.system(.subheadline, design: .rounded))
                                                .foregroundColor(.appCarob)
                                            Text(doc.firstAuthor)
                                                .font(.system(.caption, design: .rounded))
                                                .foregroundColor(.appCarob.opacity(0.6))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .listRowBackground(Color.appVanilla)
                    
                    Section(header: Text("Verified Metadata").foregroundColor(.appCarob)) {
                        TextField("Book Title", text: $inputTitle)
                            .foregroundColor(.appCarob)
                        TextField("Author Name", text: $inputAuthor)
                            .foregroundColor(.appCarob)
                        TextField("Genre Category", text: $inputGenre)
                            .foregroundColor(.appCarob)
                    }
                    .listRowBackground(Color.appVanilla)
                    
                    Section(header: Text("Blind Quote configuration").foregroundColor(.appCarob)) {
                        TextEditor(text: $inputQuote)
                            .frame(height: 70)
                            .foregroundColor(.appCarob)
                    }
                    .listRowBackground(Color.appVanilla)
                    
                    Button(action: {
                        viewModel.addNewBookToShelf(
                            title: inputTitle,
                            author: inputAuthor,
                            genre: inputGenre,
                            quote: inputQuote,
                            coverUrl: onlineCoverUrl
                        )
                        dismiss()
                    }) {
                        Text("List Book to My Shelf")
                            .font(.system(.headline, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(inputTitle.isEmpty || inputAuthor.isEmpty ? Color.appPistache : Color.appMatcha)
                            .cornerRadius(12)
                    }
                    .disabled(inputTitle.isEmpty || inputAuthor.isEmpty)
                    .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Add New Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                        .foregroundColor(.appCarob)
                }
            }
        }
    }
}

//#Preview {
//    AddNewBookForm(viewModel: MyShelfViewModel)
//}
