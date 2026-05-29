//
//  DIscoveryView.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import SwiftUI

struct DiscoveryView: View {
    @StateObject private var viewModel = DiscoveryViewModel()
    @State private var showFilterSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background utama sewarna Almond lembut
                Theme.almond.opacity(0.3).ignoresSafeArea()
                
                VStack {
                    if viewModel.filteredBooks.isEmpty {
                        // Tampilan saat buku kosong / tidak cocok filter
                        VStack(spacing: 15) {
                            Image("dummy_mascot_sad") // Placeholder maskot sedih
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("No mystery books found around you.")
                                .font(.headline)
                                .foregroundColor(Theme.carob)
                            Text("Try changing your filter preference.")
                                .font(.subheadline)
                                .foregroundColor(Theme.carob.opacity(0.6))
                        }
                        .padding()
                    } else {
                        // Tampilan buku misteri utama swipeable / scrollable stack
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 20) {
                                ForEach(viewModel.filteredBooks) { book in
                                    MysteryBookCard(
                                        book: book,
                                        onSkip: {
                                            withAnimation {
                                                // Logika skip (menghapus sementara dari view array)
                                                if let index = viewModel.filteredBooks.firstIndex(where: { $0.id == book.id }) {
                                                    viewModel.filteredBooks.remove(at: index)
                                                }
                                            }
                                        },
                                        onRequestSwap: {
                                            // Trigger fungsi swap (Nanti disambungkan ke halaman Match milik Eileen)
                                            print("Request swap untuk buku ID: \(book.id)")
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 15)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Discover")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .foregroundColor(Theme.carob)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showFilterSheet.toggle() }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title2)
                            .foregroundColor(Theme.matcha)
                    }
                }
            }
            .sheet(isPresented: $showFilterSheet) {
                FilterSheetView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.loadBooks()
            }
        }
    }
}
