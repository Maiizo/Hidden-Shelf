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
    @State private var inputPublisher = ""
    @State private var inputPageCount = 0
    @State private var inputQuote = ""
    @State private var onlineCoverUrl: String? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background base color
                Color.appAlmond.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // SECTION 1: SEARCH DATABASE CARD
                        VStack(alignment: .leading, spacing: 10) {
                            Text("AUTO-FILL SEARCH")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(.appCarob.opacity(0.6))
                                .padding(.leading, 4)
                            
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.appCarob.opacity(0.7))
                                TextField("Type title here to look up...", text: $viewModel.apiSearchQuery)
                                    .font(.system(.body, design: .rounded))
                                    .foregroundColor(.appCarob)
                                
                                if viewModel.isSearchingAPI {
                                    ProgressView()
                                        .controlSize(.small)
                                }
                            }
                            .padding(14)
                            .background(Color.appAlmond)
                            .cornerRadius(12)
                            
                            // Replace the floating dropdown section in your AddNewBookForm with this:
                            if !viewModel.apiResults.isEmpty {
                                VStack(spacing: 0) {
                                    ForEach(viewModel.apiResults) { doc in
                                        Button(action: {
                                            inputTitle = doc.title
                                            inputAuthor = doc.firstAuthor
                                            inputGenre = doc.firstGenre
                                            inputPublisher = doc.firstPublisher
                                            inputPageCount = doc.totalPages
                                            onlineCoverUrl = doc.formattedCoverUrl
                                            viewModel.apiResults = []
                                            viewModel.apiSearchQuery = ""
                                        }) {
                                            HStack(spacing: 12) {
                                                if let urlStr = doc.formattedCoverUrl, let url = URL(string: urlStr) {
                                                    CachedAsyncImage(url: url) {
                                                        RoundedRectangle(cornerRadius: 4)
                                                            .fill(Color.appPistache.opacity(0.3))
                                                    }
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 24, height: 34)
                                                    .cornerRadius(4)
                                                    .clipped()
                                                } else {
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .fill(Color.appPistache.opacity(0.4))
                                                        .frame(width: 24, height: 34)
                                                }
                                                
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(doc.title)
                                                        .font(.system(size: 13, weight: .bold, design: .rounded))
                                                        .foregroundColor(.appCarob)
                                                        .lineLimit(1)
                                                    // FIXED: Removed the 0 hlm page count string from the preview
                                                    Text(doc.firstAuthor)
                                                        .font(.system(size: 11, design: .rounded))
                                                        .foregroundColor(.appCarob.opacity(0.6))
                                                        .lineLimit(1)
                                                }
                                                
                                                Spacer()
                                                
                                                Image(systemName: "arrow.down.circle.fill")
                                                    .font(.system(size: 16))
                                                    .foregroundColor(.appMatcha)
                                            }
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 10)
                                        }
                                        
                                        if doc.id != viewModel.apiResults.last?.id {
                                            Divider().background(Color.appAlmond.opacity(0.6))
                                        }
                                    }
                                }
                                .background(Color.appAlmond.opacity(0.4))
                                .cornerRadius(12)
                                .transition(.opacity)
                            }
                        }
                        
                        // SECTION 2: VERIFIED METADATA CARD
                        VStack(alignment: .leading, spacing: 16) {
                            Text("BOOK METADATA DETAILS")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(.appCarob.opacity(0.6))
                                .padding(.leading, 4)
                            
                            ElegantInputField(label: "Book Title", placeholder: "e.g., The Stranger", text: $inputTitle)
                            ElegantInputField(label: "Author Name", placeholder: "e.g., Albert Camus", text: $inputAuthor)
                            ElegantInputField(label: "Genre Category", placeholder: "e.g., Philosophy", text: $inputGenre)
                            ElegantInputField(label: "Penerbit (Publisher)", placeholder: "e.g., Vintage Books", text: $inputPublisher)
                            
                            // Numeric Page Field Block
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Jumlah Halaman")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(.appCarob.opacity(0.8))
                                
                                HStack {
                                    Image(systemName: "doc.text")
                                        .foregroundColor(.appCarob.opacity(0.4))
                                    TextField("0", value: $inputPageCount, formatter: NumberFormatter())
                                        .keyboardType(.numberPad)
                                        .foregroundColor(.appCarob)
                                }
                                .padding(12)
                                .background(Color.appAlmond)
                                .cornerRadius(10)
                            }
                        }
                        .padding(16)
                        .background(Color.appVanilla)
                        .cornerRadius(18)
                        
                        // SECTION 3: BLIND QUOTE CARD
                        VStack(alignment: .leading, spacing: 10) {
                            Text("BLIND QUOTE CONFIGURATION")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(.appCarob.opacity(0.6))
                                .padding(.leading, 4)
                            
                            TextEditor(text: $inputQuote)
                                .frame(height: 80)
                                .padding(8)
                                .scrollContentBackground(.hidden)
                                .background(Color.appAlmond)
                                .cornerRadius(12)
                                .foregroundColor(.appCarob)
                        }
                        .padding(16)
                        .background(Color.appVanilla)
                        .cornerRadius(18)
                        
                        // ACTION LAUNCH BUTTON
                        Button(action: {
                            viewModel.addNewBookToShelf(
                                title: inputTitle,
                                author: inputAuthor,
                                genre: inputGenre,
                                publisher: inputPublisher,
                                pageCount: inputPageCount,
                                quote: inputQuote,
                                coverUrl: onlineCoverUrl
                            )
                            dismiss()
                        }) {
                            Text("List Book to My Shelf")
                                .font(.system(.headline, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(inputTitle.isEmpty || inputAuthor.isEmpty ? Color.appPistache : Color.appMatcha)
                                .cornerRadius(14)
                                .shadow(color: Color.appMatcha.opacity(0.2), radius: 6, x: 0, y: 4)
                        }
                        .disabled(inputTitle.isEmpty || inputAuthor.isEmpty)
                        .padding(.top, 10)
                    }
                    .padding(16)
                }
            }
            .navigationTitle("Add New Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.appCarob)
                }
            }
        }
    }
}

// Reusable custom field utility component for code clarity
struct ElegantInputField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(.appCarob.opacity(0.8))
            
            TextField(placeholder, text: $text)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.appCarob)
                .padding(12)
                .background(Color.appAlmond)
                .cornerRadius(10)
        }
    }
}
