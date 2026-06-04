import SwiftUI

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() {}
    private let cache = NSCache<NSURL, UIImage>()
    
    func get(url: URL) -> UIImage? { cache.object(forKey: url as NSURL) }
    func set(url: URL, image: UIImage) { cache.setObject(image, forKey: url as NSURL) }
}

struct CachedAsyncImage<Placeholder: View>: View {
    let url: URL
    @ViewBuilder let placeholder: () -> Placeholder
    @State private var downloadedImage: UIImage? = nil
    
    var body: some View {
        Group {
            if let image = downloadedImage {
                Image(uiImage: image).resizable()
            } else { placeholder() }
        }
        .task(id: url) {
            if let cached = ImageCacheManager.shared.get(url: url) {
                self.downloadedImage = cached
                return
            }
            if let (data, _) = try? await URLSession.shared.data(from: url), let uiImage = UIImage(data: data) {
                ImageCacheManager.shared.set(url: url, image: uiImage)
                self.downloadedImage = uiImage
            }
        }
    }
}

struct MyShelfView: View {
    @StateObject private var viewModel = MyShelfViewModel()
    @State private var isShowingAddSheet = false
    @State private var isShowingFilterDrawer = false
    @State private var bookToEdit: Book? // State untuk memunculkan halaman Edit
    
    private let gridColumns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    
    var body: some View {
        ZStack {
            Theme.almond.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Area Component
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("My Shelf")
                            .font(.system(size: 32, weight: .bold, design: .serif)) // Themed Serif
                            .foregroundColor(Theme.carob)
                    }
                    Spacer()
                    
                    // Filter Panel Trigger
                    Button(action: { withAnimation(.spring()) { isShowingFilterDrawer.toggle() } }) {
                        Image(systemName: "line.3.horizontal.decrease.circle\(isShowingFilterDrawer ? ".fill" : "")")
                            .font(.system(size: 16, weight: .bold)).foregroundColor(Theme.carob)
                            .frame(width: 40, height: 40).background(Theme.vanilla).cornerRadius(12)
                    }
                    .padding(.trailing, 4)
                    
                    // Grid / List Toggler
                    Button(action: { withAnimation(.spring()) { viewModel.viewMode = (viewModel.viewMode == .card) ? .list : .card } }) {
                        Image(systemName: viewModel.viewMode == .card ? "list.bullet" : "square.grid.2x2")
                            .font(.system(size: 16, weight: .bold)).foregroundColor(Theme.carob)
                            .frame(width: 40, height: 40).background(Theme.vanilla).cornerRadius(12)
                    }
                }
                .padding()
                
                // FILTER DRAWER
                if isShowingFilterDrawer {
                    VStack(spacing: 10) {
                        HStack(spacing: 12) {
                            FilterDropdownMenu(label: "Genre", selection: $viewModel.selectedGenreFilter, options: viewModel.uniqueGenres)
                            FilterDropdownMenu(label: "Author", selection: $viewModel.selectedAuthorFilter, options: viewModel.uniqueAuthors)
                        }
                        
                        HStack(spacing: 12) {
                            FilterDropdownMenu(
                                label: "Penerbit",
                                selection: $viewModel.selectedPublisherFilter,
                                options: viewModel.uniquePublishers
                            )
                            FilterPageDropdownMenu(
                                label: "Halaman",
                                selection: $viewModel.selectedPageFilter
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Urutkan Berdasarkan")
                                .font(.system(size: 10, weight: .bold, design: .serif))
                                .foregroundColor(Theme.carob)
                            Picker("Sort", selection: $viewModel.selectedSortOption) {
                                ForEach(SortOption.allCases, id: \.self) { option in
                                    Text(option.rawValue).tag(option)
                                }
                            }
                            .pickerStyle(.segmented)
                            .controlSize(.small)
                        }
                    }
                    .padding(12)
                    .background(Theme.vanilla)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
                
                // Active Core Section Tab Switch Bar
                HStack(spacing: 0) {
                    SegmentButton(title: "Available", status: .available, activeStatus: $viewModel.activeTab)
                    SegmentButton(title: "Swapped", status: .swapped, activeStatus: $viewModel.activeTab)
                }
                .padding(.horizontal).padding(.bottom, 12)
                
                // Dynamic Content Render Output Workspace
                ScrollView {
                    VStack(spacing: 0) {
                        if viewModel.filteredBooks.isEmpty {
                            EmptyShelfStateView(tab: viewModel.activeTab)
                                .padding(.top, 100)
                        } else {
                            if viewModel.viewMode == .card {
                                LazyVGrid(columns: gridColumns, spacing: 16) {
                                    ForEach(viewModel.filteredBooks) { book in
                                        CardBookItemView(book: book)
                                            // Context Menu untuk fitur Edit
                                            .contextMenu {
                                                Button { bookToEdit = book } label: {
                                                    Label("Edit Buku", systemImage: "pencil")
                                                }
                                            }
                                    }
                                }
                                .padding()
                            } else {
                                LazyVStack(spacing: 12) {
                                    ForEach(viewModel.filteredBooks) { book in
                                        ListBookItemView(book: book)
                                            // Context Menu untuk fitur Edit
                                            .contextMenu {
                                                Button { bookToEdit = book } label: {
                                                    Label("Edit Buku", systemImage: "pencil")
                                                }
                                            }
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                    .id(viewModel.activeTab)
                }
                .animation(.easeInOut(duration: 0.2), value: viewModel.activeTab)
            }
            
            // Bottom Right Mounted FAB
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { isShowingAddSheet.toggle() }) {
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .bold)).foregroundColor(.white)
                            .frame(width: 56, height: 56).background(Theme.matcha).clipShape(Circle())
                            .shadow(color: Theme.carob.opacity(0.25), radius: 5, x: 0, y: 4)
                    }
                    .padding(.trailing, 20).padding(.bottom, 16)
                }
            }
        }
        .sheet(isPresented: $isShowingAddSheet) { AddNewBookForm(viewModel: viewModel) }
        .sheet(item: $bookToEdit) { book in
            EditBookView(viewModel: viewModel, book: book)
        }
    }
}

// Komponen Filter (Menggunakan Theme Global)
struct FilterDropdownMenu: View {
    let label: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 10, weight: .bold, design: .serif))
                .foregroundColor(Theme.carob)
            
            Menu {
                Picker(label, selection: $selection) {
                    ForEach(options, id: \.self) { opt in Text(opt).tag(opt) }
                }
            } label: {
                HStack {
                    Text(selection).lineLimit(1).minimumScaleFactor(0.7)
                    Spacer(minLength: 4)
                    Image(systemName: "chevron.up.chevron.down").font(.system(size: 10))
                }
                .font(.system(size: 13, weight: .medium, design: .serif))
                .foregroundColor(Theme.carob)
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity, minHeight: 30)
                .background(Theme.almond)
                .cornerRadius(6)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct FilterPageDropdownMenu: View {
    let label: String
    @Binding var selection: PageRangeOption
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 10, weight: .bold, design: .serif))
                .foregroundColor(Theme.carob)
            
            Menu {
                Picker(label, selection: $selection) {
                    ForEach(PageRangeOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            } label: {
                HStack {
                    Text(selection.rawValue).lineLimit(1).minimumScaleFactor(0.7)
                    Spacer(minLength: 4)
                    Image(systemName: "chevron.up.chevron.down").font(.system(size: 10))
                }
                .font(.system(size: 13, weight: .medium, design: .serif))
                .foregroundColor(Theme.carob)
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity, minHeight: 30)
                .background(Theme.almond)
                .cornerRadius(6)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct SegmentButton: View {
    let title: String
    let status: ShelfStatus
    @Binding var activeStatus: ShelfStatus
    
    var body: some View {
        Button(action: { activeStatus = status }) {
            VStack(spacing: 6) {
                Text(title).font(.system(.headline, design: .serif))
                    .foregroundColor(activeStatus == status ? Theme.carob : Theme.carob.opacity(0.5))
                Capsule().fill(activeStatus == status ? Theme.matcha : Color.clear).frame(height: 3)
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
                CachedAsyncImage(url: url) { ProgressView().frame(height: 150) }
                    .aspectRatio(contentMode: .fill).frame(height: 150).cornerRadius(10).clipped()
            } else {
                RoundedRectangle(cornerRadius: 10).fill(Theme.pistache).frame(height: 150)
            }
            
            Text(book.title).font(.system(.subheadline, design: .serif)).fontWeight(.bold).foregroundColor(Theme.carob).lineLimit(1)
            Text(book.author).font(.system(.caption, design: .serif)).foregroundColor(Theme.carob.opacity(0.7)).lineLimit(1)
            
            HStack(spacing: 4) {
                Text("\(book.pageCount) hlm").font(.system(size: 9, weight: .semibold))
                    .padding(.horizontal, 6).padding(.vertical, 3).background(Theme.almond).cornerRadius(4)
                Text(book.genre).font(.system(size: 9, weight: .bold))
                    .padding(.horizontal, 6).padding(.vertical, 3).background(Theme.chai.opacity(0.25)).cornerRadius(4)
            }
            .foregroundColor(Theme.carob)
        }
        .padding(12).background(Theme.vanilla).cornerRadius(16)
    }
}

struct ListBookItemView: View {
    let book: Book
    
    var body: some View {
        HStack(spacing: 14) {
            if let coverUrl = book.coverUrl, let url = URL(string: coverUrl) {
                CachedAsyncImage(url: url) { ProgressView().frame(width: 55, height: 75) }
                    .aspectRatio(contentMode: .fill).frame(width: 55, height: 75).cornerRadius(8).clipped()
            } else {
                RoundedRectangle(cornerRadius: 8).fill(Theme.pistache).frame(width: 55, height: 75)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title).font(.system(.headline, design: .serif)).foregroundColor(Theme.carob).lineLimit(1)
                Text("Oleh \(book.author)  •  \(book.publisher)").font(.system(.caption, design: .serif)).foregroundColor(Theme.carob.opacity(0.7)).lineLimit(1)
                
                HStack(spacing: 6) {
                    Text("\(book.pageCount) Halaman").font(.system(size: 9, weight: .semibold))
                        .padding(.horizontal, 6).padding(.vertical, 2).background(Theme.almond).cornerRadius(4)
                    Text(book.genre).font(.system(size: 9, weight: .bold))
                        .padding(.horizontal, 6).padding(.vertical, 2).background(Theme.chai.opacity(0.25)).cornerRadius(4)
                }
                .foregroundColor(Theme.carob).padding(.top, 2)
            }
            Spacer()
        }
        .padding(12).background(Theme.vanilla).cornerRadius(16)
    }
}

struct EmptyShelfStateView: View {
    let tab: ShelfStatus
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer(); Spacer(); Spacer(); Spacer()
            ZStack {
                Circle().fill(Theme.pistache.opacity(0.3)).frame(width: 180, height: 180)
                Image(tab == .available ? "Book" : "Box")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
            }
            
            Text(tab == .available ? "No books in shelf" : "History empty")
                .font(.system(.headline, design: .serif)).foregroundColor(Theme.carob)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
