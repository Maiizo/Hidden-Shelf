//
//  ProfileView.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Header (Avatar & User Info)
                    VStack(spacing: 12) {
                        // Avatar - Menggunakan gambar Reading
                        Image("Hahoh")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color(hex: "B3B792"), lineWidth: 2)
                            )
                        
                        VStack(spacing: 4) {
                            Text("Sarah Johnson")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: "725C3A"))
                            
                            Text("@bookworm_sarah")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "725C3A").opacity(0.7))
                        }
                    }
                    .padding(.top, 20)
                    
                    // MARK: - Stats Row (Books Shared & Swaps Made)
                    HStack(spacing: 24) {
                        StatCard(value: "23", title: "Books Shared")
                        StatCard(value: "17", title: "Swaps Made")
                    }
                    .padding(.horizontal, 20)
                    
                    // MARK: - Settings Menu
                    VStack(spacing: 0) {
                        SettingsMenuItem(icon: "bell.fill", title: "Notifications", color: Color(hex: "809671"))
                        
                        Divider()
                            .background(Color(hex: "B3B792").opacity(0.3))
                            .padding(.leading, 52)
                        
                        SettingsMenuItem(icon: "lock.fill", title: "Privacy", color: Color(hex: "809671"))
                        
                        Divider()
                            .background(Color(hex: "B3B792").opacity(0.3))
                            .padding(.leading, 52)
                        
                        SettingsMenuItem(icon: "info.circle.fill", title: "About", color: Color(hex: "809671"))
                    }
                    .background(Color(hex: "E5D2B8"))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    
                    // MARK: - Home Screen Widgets Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Home Screen Widgets")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "725C3A"))
                            .padding(.horizontal, 4)
                        
                        // Small Widget
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Small Widget")
                                .font(.caption)
                                .foregroundColor(Color(hex: "725C3A").opacity(0.7))
                            
                            SmallWidgetCard()
                        }
                        
                        // Medium Widget
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Medium Widget")
                                .font(.caption)
                                .foregroundColor(Color(hex: "725C3A").opacity(0.7))
                            
                            MediumWidgetCard()
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // MARK: - Version Footer
                    VStack(spacing: 4) {
                        Text("Hidden Shelf v1.0")
                            .font(.caption2)
                            .foregroundColor(Color(hex: "725C3A").opacity(0.5))
                        
                        Text("Sustainable book swapping")
                            .font(.caption2)
                            .foregroundColor(Color(hex: "725C3A").opacity(0.4))
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                }
            }
            .background(Color(hex: "E5E0D8"))
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Stat Card Component
struct StatCard: View {
    let value: String
    let title: String
    
    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "809671"))
            
            Text(title)
                .font(.caption)
                .foregroundColor(Color(hex: "725C3A").opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(hex: "E5D2B8"))
        .cornerRadius(16)
    }
}

// MARK: - Settings Menu Item Component
struct SettingsMenuItem: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(color)
                .frame(width: 28, height: 28)
            
            Text(title)
                .font(.body)
                .foregroundColor(Color(hex: "725C3A"))
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Color(hex: "B3B792"))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
        .onTapGesture {
            print("\(title) tapped")
        }
    }
}

// MARK: - Small Widget Card
struct SmallWidgetCard: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "E5D2B8"))
                .frame(width: 160, height: 160)
                .shadow(color: Color(hex: "725C3A").opacity(0.1), radius: 8, x: 0, y: 4)
            
            VStack(spacing: 12) {
                Image(systemName: "quote.opening")
                    .font(.title2)
                    .foregroundColor(Color(hex: "D2AB80"))
                    .padding(.top, 8)
                
                Text("\"Reading is dreaming with open eyes\"")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: "725C3A"))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding(.horizontal, 12)
                
                Spacer(minLength: 0)
                
                Image(systemName: "leaf.fill")
                    .font(.caption2)
                    .foregroundColor(Color(hex: "809671"))
                    .padding(.bottom, 12)
            }
            .frame(width: 160, height: 160)
        }
    }
}

// MARK: - Medium Widget Card
struct MediumWidgetCard: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "E5D2B8"))
                .frame(height: 110)
                .shadow(color: Color(hex: "725C3A").opacity(0.1), radius: 8, x: 0, y: 4)
            
            HStack(spacing: 16) {
                VStack(spacing: 4) {
                    Image(systemName: "book.closed.fill")
                        .font(.title2)
                        .foregroundColor(Color(hex: "809671"))
                    
                    Image(systemName: "person.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(hex: "D2AB80"))
                }
                .frame(width: 50)
                .padding(.leading, 8)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Daily Mystery Quote")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "D2AB80"))
                    
                    Text("\"A room without books is like a body without a soul.\"")
                        .font(.caption2)
                        .foregroundColor(Color(hex: "725C3A"))
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("- Marcus Tullius Cicero")
                        .font(.caption2)
                        .foregroundColor(Color(hex: "725C3A").opacity(0.6))
                }
                
                Spacer()
            }
            .padding(.horizontal, 12)
        }
    }
}

// MARK: - Tab Bar Controller (Main View dengan 3 tabs)
struct MainTabView: View {
    var body: some View {
        TabView {
            DiscoverView()
                .tabItem {
                    Image(systemName: "safari")
                    Text("Discover")
                }
            
            MyShelfView()
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("My Shelf")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
        .accentColor(Color(hex: "809671"))
    }
}

// MARK: - Discover View (Simple Next & Back)
struct DiscoverView: View {
    @State private var currentIndex = 0
    @State private var books: [MysteryBook] = [
        MysteryBook(
            id: 1,
            quote: "It is only with the heart that one can see rightly; what is essential is invisible to the eye.",
            genres: ["Philosophy", "Classic"],
            pageCount: 96,
            publisher: "Wordsworth Editions"
        ),
        MysteryBook(
            id: 2,
            quote: "The only way to do great work is to love what you do.",
            genres: ["Motivation", "Self-Help"],
            pageCount: 240,
            publisher: "Penguin Books"
        ),
        MysteryBook(
            id: 3,
            quote: "Not all those who wander are lost.",
            genres: ["Fantasy", "Adventure"],
            pageCount: 384,
            publisher: "HarperCollins"
        ),
        MysteryBook(
            id: 4,
            quote: "Be the change that you wish to see in the world.",
            genres: ["Inspiration", "Classic"],
            pageCount: 112,
            publisher: "Penguin Classics"
        ),
        MysteryBook(
            id: 5,
            quote: "Stay hungry, stay foolish.",
            genres: ["Motivation", "Biography"],
            pageCount: 320,
            publisher: "HarperBusiness"
        )
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "E5E0D8")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Discover")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "725C3A"))
                        
                        Text("Your next blind date with a book")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "725C3A").opacity(0.7))
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                    
                    // Card
                    MysteryBookCard(book: books[currentIndex])
                        .frame(height: 460)
                        .animation(.easeInOut(duration: 0.3), value: currentIndex)
                    
                    // Tombol Back & Next + Counter
                    VStack(spacing: 16) {
                        HStack(spacing: 40) {
                            // Back Button
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    if currentIndex > 0 {
                                        currentIndex -= 1
                                    }
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "chevron.left")
                                        .font(.headline)
                                    Text("Back")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(currentIndex > 0 ? Color(hex: "809671") : Color(hex: "B3B792"))
                                .padding(.horizontal, 32)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(currentIndex > 0 ? Color(hex: "809671") : Color(hex: "B3B792"), lineWidth: 2)
                                        .background(Color.white.cornerRadius(16))
                                )
                            }
                            .disabled(currentIndex == 0)
                            
                            // Next Button
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    if currentIndex < books.count - 1 {
                                        currentIndex += 1
                                    }
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Text("Next")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    Image(systemName: "chevron.right")
                                        .font(.headline)
                                }
                                .foregroundColor(currentIndex < books.count - 1 ? .white : Color(hex: "B3B792"))
                                .padding(.horizontal, 32)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(currentIndex < books.count - 1 ? Color(hex: "809671") : Color(hex: "E5D2B8"))
                                )
                            }
                            .disabled(currentIndex == books.count - 1)
                        }
                        
                        // Counter
                        Text("\(currentIndex + 1) of \(books.count)")
                            .font(.caption)
                            .foregroundColor(Color(hex: "725C3A").opacity(0.6))
                    }
                    .padding(.top, 30)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Mystery Book Card Component (Untuk Discover)
struct MysteryBookCard: View {
    let book: MysteryBook
    
    var body: some View {
        ZStack {
            // Card Background
            RoundedRectangle(cornerRadius: 28)
                .fill(Color(hex: "E5D2B8"))
                .shadow(color: Color(hex: "725C3A").opacity(0.15), radius: 12, x: 0, y: 6)
            
            VStack(spacing: 0) {
                // Top decorative - Mascot peeking
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color(hex: "809671").opacity(0.15))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "person.circle.fill")
                            .font(.title)
                            .foregroundColor(Color(hex: "D2AB80"))
                            .offset(x: 8, y: -4)
                        
                        Image(systemName: "book.closed.fill")
                            .font(.caption)
                            .foregroundColor(Color(hex: "809671"))
                            .offset(x: -8, y: 6)
                    }
                    .padding(.trailing, 16)
                    .padding(.top, 12)
                }
                
                // Quote Section
                VStack(spacing: 20) {
                    Image(systemName: "quote.opening")
                        .font(.largeTitle)
                        .foregroundColor(Color(hex: "D2AB80"))
                    
                    Text("\"\(book.quote)\"")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "725C3A"))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 24)
                    
                    Image(systemName: "quote.closing")
                        .font(.largeTitle)
                        .foregroundColor(Color(hex: "D2AB80"))
                }
                .padding(.vertical, 20)
                
                Spacer()
                
                // Genre Tags & Page Count
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        ForEach(book.genres, id: \.self) { genre in
                            Text(genre)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(Color(hex: "725C3A"))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(Color(hex: "D2AB80").opacity(0.2))
                                )
                        }
                        
                        Text("\(book.pageCount) pages")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(Color(hex: "725C3A"))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color(hex: "B3B792").opacity(0.2))
                            )
                    }
                    
                    Text(book.publisher)
                        .font(.caption2)
                        .foregroundColor(Color(hex: "725C3A").opacity(0.5))
                        .padding(.bottom, 20)
                }
            }
        }
        .frame(height: 460)
    }
}

// MARK: - Swipeable Card Component
struct SwipeableCard: View {
    let book: MysteryBook
    let onRemove: (String) -> Void
    
    @State private var offset: CGSize = .zero
    @State private var color: Color = Color(hex: "E5D2B8")
    
    var body: some View {
        ZStack {
            // Card Background
            RoundedRectangle(cornerRadius: 28)
                .fill(color)
                .shadow(color: Color(hex: "725C3A").opacity(0.15), radius: 12, x: 0, y: 6)
            
            VStack(spacing: 0) {
                // Top decorative - Mascot
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color(hex: "809671").opacity(0.15))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "person.circle.fill")
                            .font(.title)
                            .foregroundColor(Color(hex: "D2AB80"))
                            .offset(x: 8, y: -4)
                        
                        Image(systemName: "book.closed.fill")
                            .font(.caption)
                            .foregroundColor(Color(hex: "809671"))
                            .offset(x: -8, y: 6)
                    }
                    .padding(.trailing, 16)
                    .padding(.top, 12)
                }
                
                // Quote
                VStack(spacing: 20) {
                    Image(systemName: "quote.opening")
                        .font(.largeTitle)
                        .foregroundColor(Color(hex: "D2AB80"))
                    
                    Text("\"\(book.quote)\"")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "725C3A"))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 24)
                    
                    Image(systemName: "quote.closing")
                        .font(.largeTitle)
                        .foregroundColor(Color(hex: "D2AB80"))
                }
                .padding(.vertical, 20)
                
                Spacer()
                
                // Tags
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        ForEach(book.genres, id: \.self) { genre in
                            Text(genre)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(Color(hex: "725C3A"))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(Capsule().fill(Color(hex: "D2AB80").opacity(0.2)))
                        }
                        
                        Text("\(book.pageCount) pages")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(Color(hex: "725C3A"))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(Color(hex: "B3B792").opacity(0.2)))
                    }
                    
                    Text(book.publisher)
                        .font(.caption2)
                        .foregroundColor(Color(hex: "725C3A").opacity(0.5))
                        .padding(.bottom, 20)
                }
            }
            
            // Swipe Indicator Overlay
            if offset.width > 0 {
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(hex: "809671").opacity(0.3))
                HStack {
                    Spacer()
                    Image(systemName: "arrow.triangle.swap")
                        .font(.largeTitle)
                        .foregroundColor(Color(hex: "809671"))
                        .padding()
                    Spacer()
                }
            } else if offset.width < 0 {
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(hex: "D2AB80").opacity(0.3))
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .font(.largeTitle)
                        .foregroundColor(Color(hex: "D2AB80"))
                        .padding()
                    Spacer()
                }
            }
        }
        .offset(x: offset.width, y: 0)
        .rotationEffect(.degrees(Double(offset.width / 20)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 150 {
                        // Swipe left (Pass) or right (Request Swap)
                        onRemove(offset.width > 0 ? "swap" : "pass")
                    } else {
                        withAnimation {
                            offset = .zero
                        }
                    }
                }
        )
    }
}

// MARK: - Mystery Book Model
struct MysteryBook: Identifiable {
    let id: Int
    let quote: String
    let genres: [String]
    let pageCount: Int
    let publisher: String
}

// MARK: - My Shelf Book Model (Hindari bentrok dengan Book di Model/Book.swift)
struct MyShelfBook: Identifiable {
    let id = UUID()
    let title: String
    let author: String
    let genre: String
}

// MARK: - My Shelf Book Card
struct MyShelfBookCard: View {
    let book: MyShelfBook
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12).fill(Color(hex: "D2AB80").opacity(0.3)).frame(width: 70, height: 100)
                Image(systemName: "book.closed.fill").font(.title).foregroundColor(Color(hex: "809671"))
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(book.title).font(.headline).fontWeight(.semibold).foregroundColor(Color(hex: "725C3A"))
                Text(book.author).font(.subheadline).foregroundColor(Color(hex: "725C3A").opacity(0.7))
                Text(book.genre).font(.caption).padding(.horizontal, 12).padding(.vertical, 4)
                    .background(Capsule().fill(Color(hex: "D2AB80").opacity(0.2))).foregroundColor(Color(hex: "725C3A"))
            }
            Spacer()
            Image(systemName: "ellipsis").font(.title3).foregroundColor(Color(hex: "B3B792"))
        }
        .padding(12).background(Color(hex: "E5D2B8")).cornerRadius(16)
        .shadow(color: Color(hex: "725C3A").opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Add Book Sheet (Untuk My Shelf)
struct MyShelfAddBookSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @State private var title = ""
    @State private var author = ""
    @State private var genre = ""
    @State private var pageCount = ""
    @State private var condition = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "E5E0D8").ignoresSafeArea()
                VStack(spacing: 0) {
                    Text("Add a New Book").font(.title2).fontWeight(.bold).foregroundColor(Color(hex: "725C3A")).padding(.top, 24)
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Search Book Title").font(.subheadline).fontWeight(.medium).foregroundColor(Color(hex: "725C3A"))
                                TextField("Type to search...", text: $searchText).padding().background(Color(hex: "E5D2B8")).cornerRadius(16)
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "B3B792").opacity(0.3), lineWidth: 1))
                            }
                            Rectangle().fill(Color(hex: "B3B792").opacity(0.3)).frame(height: 1)
                            VStack(spacing: 20) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Title").font(.subheadline).fontWeight(.medium).foregroundColor(Color(hex: "725C3A"))
                                    TextField("Book title", text: $title).padding().background(Color(hex: "E5D2B8")).cornerRadius(16)
                                }
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Author").font(.subheadline).fontWeight(.medium).foregroundColor(Color(hex: "725C3A"))
                                    TextField("Author name", text: $author).padding().background(Color(hex: "E5D2B8")).cornerRadius(16)
                                }
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Genre").font(.subheadline).fontWeight(.medium).foregroundColor(Color(hex: "725C3A"))
                                    TextField("e.g., Fiction, Mystery", text: $genre).padding().background(Color(hex: "E5D2B8")).cornerRadius(16)
                                }
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Page Count").font(.subheadline).fontWeight(.medium).foregroundColor(Color(hex: "725C3A"))
                                    TextField("Number of pages", text: $pageCount).padding().background(Color(hex: "E5D2B8")).cornerRadius(16).keyboardType(.numberPad)
                                }
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Condition").font(.subheadline).fontWeight(.medium).foregroundColor(Color(hex: "725C3A"))
                                    TextField("e.g., Good, Like New", text: $condition).padding().background(Color(hex: "E5D2B8")).cornerRadius(16)
                                }
                            }
                        }
                        .padding(.horizontal, 24).padding(.top, 20)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }.foregroundColor(Color(hex: "D2AB80"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Book") { dismiss() }.foregroundColor(Color(hex: "809671")).fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.large])
    }
}

#Preview {
    MainTabView()
}
