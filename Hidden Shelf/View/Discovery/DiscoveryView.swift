//
//  DiscoveryView.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import SwiftUI

struct DiscoveryView: View {
    @StateObject private var viewModel = DiscoveryViewModel()
    @State private var showFilterSheet = false
    
    init(previewBooks: [Book]? = nil) {
        if let dummyBooks = previewBooks {
            let vm = DiscoveryViewModel()
            vm.allBooks = dummyBooks
            vm.filteredBooks = dummyBooks
            _viewModel = StateObject(wrappedValue: vm)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background utama
                Theme.almond.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    // 1. DROPDOWN FILTER
                    if showFilterSheet {
                        FilterSheetView(viewModel: viewModel, onClose: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showFilterSheet = false
                            }
                        })
                        .padding(.horizontal, 24)
                        .padding(.top, 90) 
                        .padding(.bottom, 15)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .zIndex(2) // Memastikan filter selalu berada di layer teratas
                    }
                    
                    // 2. HEADER UTAMA: Hidden Shelf, Maskot, & Sapaan
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .center) {
                            Text("Hidden Shelf")
                                .font(.system(size: 32, weight: .bold, design: .serif))
                                .foregroundColor(Color(hex: "725C3A")) // Carob
                            
                            Spacer()
                            
                            // Maskot dengan Background Lingkaran Pistache
                            Image("Reading")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .background(
                                    Circle()
                                        .fill(Theme.almond)
                                        .frame(width: 80, height: 80)
                                        .offset(y: 5)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Hai, Chelsea!")
                                .font(.system(size: 24, weight: .bold, design: .serif))
                                .foregroundColor(Color(hex: "725C3A"))
                            
                            Text("Siap menemukan cerita baru hari ini?")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "725C3A").opacity(0.7))
                        }
                        .padding(.top, -15)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 15)
                    .padding(.bottom, 15)
                    
                    // 3. AREA TENGAH: Kartu Buku Misteri
                    if viewModel.filteredBooks.isEmpty {
                        Spacer()
                        VStack(spacing: 15) {
                            Image("Box")
                                .resizable()
                                .frame(width: 120, height: 120)
                                .scaledToFit()
                                .background(
                                    Circle()
                                        .fill(Theme.pistache)
                                        .frame(width: 180, height: 180)
                                        .offset(y: 5)
                                )
                            Text("No mystery books found around you.")
                                .font(.headline)
                                .foregroundColor(Color(hex: "725C3A"))
                                .padding(.top, 15)
                            Text("Try changing your filter preference.")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "725C3A").opacity(0.6))
                        }
                        .padding()
                        Spacer()
                    } else {
                        Spacer()
                        
                        // FIX 2: ZStack Kartu tanpa .enumerated() agar SwiftUI bisa melacak animasi
                        ZStack {
                            ForEach(viewModel.filteredBooks.reversed(), id: \.id) { book in
                                
                                // Cek apakah buku ini adalah buku urutan pertama (paling atas)
                                let isTopCard = book.id == viewModel.filteredBooks.first?.id
                                
                                MysteryBookCard(
                                    book: book,
                                    onSkip: {
                                        // Animasi saat ditekan tombol skip
                                        withAnimation(.easeInOut(duration: 0.35)) {
                                            if let targetIndex = viewModel.filteredBooks.firstIndex(where: { $0.id == book.id }) {
                                                viewModel.filteredBooks.remove(at: targetIndex)
                                            }
                                        }
                                    },
                                    onRequestSwap: {
                                        print("Request swap untuk buku ID: \(book.id)")
                                    }
                                )
                                .background(Color.white)
                                .cornerRadius(24)
                                .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
                                .disabled(!isTopCard) // Hanya kartu paling depan yang bisa diklik
                                .zIndex(isTopCard ? 1 : 0) // Jaga posisi Z agar kartu yang dianimasikan tetap di atas
                                // Efek menghilang: mengecil sedikit sambil memudar
                                .transition(.asymmetric(
                                    insertion: .identity,
                                    removal: .scale(scale: 0.85).combined(with: .opacity)
                                ))
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        Spacer()
                    }
                    
                    // 4. NAV BAR BUFFER
                    Spacer()
                        .frame(height: 75)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showFilterSheet.toggle()
                        }
                    }) {
                        Image(systemName: showFilterSheet ? "xmark.circle.fill" : "line.3.horizontal.decrease.circle")
                            .font(.title2)
                            .foregroundColor(Color(hex: "809671"))
                    }
                }
            }
            .onAppear {
                if viewModel.allBooks.isEmpty {
                    viewModel.loadBooks()
                }
            }
        }
    }
}

