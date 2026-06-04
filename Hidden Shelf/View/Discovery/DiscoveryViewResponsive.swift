//
//  DiscoveryView.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import SwiftUI

struct DiscoveryViewResponsive: View {
    @StateObject private var viewModel = DiscoveryViewModel()
    @State private var showFilterSheet = false
    
    // 💡 Responsive Layout: Mendeteksi jenis layar secara dinamis
    #if os(macOS)
    private var isRegular: Bool { true }
    #else
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    private var isRegular: Bool { horizontalSizeClass == .regular }
    #endif
    
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
                Color(hex: "E5E0D8").opacity(0.4).ignoresSafeArea()
                
                if isRegular {
                    // MARK: - TAMPILAN IPAD & MAC
                    VStack(spacing: 0) {
                        HStack(alignment: .top, spacing: 40) {
                            // Sisi Kiri: Panel Filter Menetap
                            FilterSheetView(viewModel: viewModel, onClose: {})
                                .frame(width: 320)
                                .padding(.top, 20)
                            
                            // Sisi Kanan: Header dan Area Tumpukan Kartu
                            VStack(spacing: 20) {
                                headerSection
                                cardStackSection
                            }
                        }
                        .padding(30)
                        
                        // 👈 NAV BAR BUFFER UNTUK IPAD/MAC
                        Spacer()
                            .frame(height: 75)
                    }
                    
                } else {
                    // MARK: - TAMPILAN IPHONE
                    VStack(spacing: 0) {
                        
                        // Dropdown Filter
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
                            .zIndex(2)
                        }
                        
                        headerSection
                            .padding(.horizontal, 24)
                            .padding(.top, 15)
                            .padding(.bottom, 15)
                        
                        cardStackSection
                            .padding(.horizontal, 24)
                        
                        // 👈 NAV BAR BUFFER UNTUK IPHONE (Kembali ke tempat semula)
                        Spacer()
                            .frame(height: 75)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !isRegular {
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
            }
            .onAppear {
                if viewModel.allBooks.isEmpty {
                    viewModel.loadBooks()
                }
            }
        }
    }
    
    // MARK: - EXTRACTED SUBVIEWS
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                Text("Hidden Shelf")
                    .font(.system(size: 32, weight: .bold, design: .serif))
                    .foregroundColor(Color(hex: "725C3A"))
                
                Spacer()
                
                Image("Reading")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 85, height: 100)
                    .background(
                        Circle()
                            .fill(Theme.pistache)
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
    }
    
    private var cardStackSection: some View {
        Group {
            if viewModel.filteredBooks.isEmpty {
                Spacer()
                VStack(spacing: 15) {
                    Image("Box")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                        .background(
                            Circle()
                                .fill(Theme.pistache)
                                .frame(width: 80, height: 80)
                                .offset(y: 5)
                        )
                    Text("No mystery books found around you.")
                        .font(.headline)
                        .foregroundColor(Color(hex: "725C3A"))
                    Text("Try changing your filter preference.")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "725C3A").opacity(0.6))
                }
                .padding()
                Spacer()
            } else {
                Spacer()
                ZStack {
                    ForEach(viewModel.filteredBooks.reversed(), id: \.id) { book in
                        let isTopCard = book.id == viewModel.filteredBooks.first?.id
                        
                        MysteryBookCard(
                            book: book,
                            onSkip: {
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
                        .disabled(!isTopCard)
                        .zIndex(isTopCard ? 1 : 0)
                        .transition(.asymmetric(
                            insertion: .identity,
                            removal: .scale(scale: 0.85).combined(with: .opacity)
                        ))
                    }
                }
                .frame(maxWidth: isRegular ? 460 : .infinity)
                Spacer()
            }
        }
    }
}
