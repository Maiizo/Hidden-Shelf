//
//  MyShelfVIew.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import SwiftUI

      extension Color {
        static let appMatcha = Color(red: 0.502, green: 0.588, blue: 0.443)    // #809671
        static let appAlmond = Color(red: 0.898, green: 0.878, blue: 0.847)    // #E5E0D8
        static let appPistache = Color(red: 0.702, green: 0.718, blue: 0.573)  // #B3B792
        static let appChai = Color(red: 0.824, green: 0.671, blue: 0.502)      // #D2AB80
        static let appCarob = Color(red: 0.447, green: 0.361, blue: 0.227)     // #725C3A
        static let appVanilla = Color(red: 0.898, green: 0.824, blue: 0.722)   // #E5D2B8
    }

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() {}
    private let cache = NSCache<NSURL, UIImage>()
    
    func get(url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    func set(url: URL, image: UIImage) {
        cache.setObject(image, forKey: url as NSURL)
    }
}

    struct MyShelfView: View {
        @StateObject private var viewModel = MyShelfViewModel()
        @State private var isShowingAddSheet = false
        
        private let gridColumns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ]
        
        var body: some View {
            ZStack {
                Color.appAlmond
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Customized Brand Header Area
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("My Shelf")
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.appCarob)
                            Text("Manage your listed items and collections.")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.appCarob.opacity(0.8))
                        }
                        Spacer()
                        
                        // Grid / List Layout State Toggle
                        Button(action: {
                            withAnimation(.spring()) {
                                viewModel.viewMode = (viewModel.viewMode == .card) ? .list : .card
                            }
                        }) {
                            Image(systemName: viewModel.viewMode == .card ? "list.bullet" : "square.grid.2x2")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.appCarob)
                                .frame(width: 40, height: 40)
                                .background(Color.appVanilla)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    
                    // Active Section Tab Controller
                    HStack(spacing: 0) {
                        SegmentButton(title: "Available", status: .available, activeStatus: $viewModel.activeTab)
                        SegmentButton(title: "Swapped", status: .swapped, activeStatus: $viewModel.activeTab)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                    
                    // Dynamic Content Render Layout
                    ScrollView {
                        if viewModel.filteredBooks.isEmpty {
                            EmptyShelfStateView(tab: viewModel.activeTab)
                                .padding(.top, 80)
                        } else {
                            if viewModel.viewMode == .card {
                                LazyVGrid(columns: gridColumns, spacing: 16) {
                                    ForEach(viewModel.filteredBooks) { book in
                                        CardBookItemView(book: book)
                                    }
                                }
                                .padding()
                            } else {
                                LazyVStack(spacing: 12) {
                                    ForEach(viewModel.filteredBooks) { book in
                                        ListBookItemView(book: book)
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
                
                // Repositioned Floating Action Button (FAB) at Bottom Right
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { isShowingAddSheet.toggle() }) {
                            Image(systemName: "plus")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Color.appMatcha)
                                .clipShape(Circle())
                                .shadow(color: Color.appCarob.opacity(0.25), radius: 5, x: 0, y: 4)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 16)
                    }
                }
            }
            // FIXED: Corrected reference string mismatch to directly invoke AddNewBookForm
            .sheet(isPresented: $isShowingAddSheet) {
                AddNewBookForm(viewModel: viewModel)
            }
        }
    }

    // Internal Interface Modules
    struct SegmentButton: View {
        let title: String
        let status: ShelfStatus
        @Binding var activeStatus: ShelfStatus
        
        var body: some View {
            Button(action: {
                withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.7)) {
                    activeStatus = status
                }
            }) {
                VStack(spacing: 6) {
                    Text(title)
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(activeStatus == status ? .appCarob : .appCarob.opacity(0.5))
                    
                    Capsule()
                        .fill(activeStatus == status ? Color.appMatcha : Color.clear)
                        .frame(height: 3)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    struct CardBookItemView: View {
        let book: Book
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                if let coverUrl = book.coverUrl, let url = URL(string: coverUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 150)
                    .cornerRadius(10)
                    .clipped()
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.appPistache)
                        .frame(height: 150)
                }
                
                Text(book.title)
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.appCarob)
                    .lineLimit(1)
                
                Text(book.author)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.appCarob.opacity(0.7))
                    .lineLimit(1)
                
                Text(book.genre)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.appChai.opacity(0.25))
                    .foregroundColor(.appCarob)
                    .cornerRadius(6)
            }
            .padding(12)
            .background(Color.appVanilla)
            .cornerRadius(16)
        }
    }

    struct ListBookItemView: View {
        let book: Book
        
        var body: some View {
            HStack(spacing: 14) {
                if let coverUrl = book.coverUrl, let url = URL(string: coverUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 55, height: 75)
                    .cornerRadius(8)
                    .clipped()
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.appPistache)
                        .frame(width: 55, height: 75)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(book.title)
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.appCarob)
                    Text(book.author)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.appCarob.opacity(0.7))
                    Text(book.genre)
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.appChai.opacity(0.25))
                        .foregroundColor(.appCarob)
                        .cornerRadius(6)
                }
                Spacer()
            }
            .padding(12)
            .background(Color.appVanilla)
            .cornerRadius(16)
        }
    }

    struct EmptyShelfStateView: View {
        let tab: ShelfStatus
        
        var body: some View {
            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.appPistache.opacity(0.3))
                        .frame(width: 90, height: 90)
                    Image(systemName: tab == .available ? "books.vertical.fill" : "archivebox.fill")
                        .font(.system(size: 34))
                        .foregroundColor(.appCarob)
                }
                
                Text(tab == .available ? "No books available" : "History empty")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.appCarob)
                Text(tab == .available ? "Tap the '+' icon to search your book title." : "Completed handoffs will appear right here.")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.appCarob.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
    }
//#Preview {
//    MyShelfVIew()
//}
