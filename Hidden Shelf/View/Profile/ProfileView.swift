//
//  ProfileView.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import SwiftUI

struct ProfileView: View {
    // MARK: - State Variables
    @State private var showingLocationSheet = false
    @State private var selectedCity = "Jakarta"
    @State private var showingMatchView = false
    @State private var selectedSwap: SwapItem? = nil
    
    // MARK: - Dummy Data untuk Ongoing Swaps
    @State private var ongoingSwaps: [SwapItem] = [
        SwapItem(id: "1", bookTitle: "The Midnight Library", requesterName: "Alex Chen", status: "Waiting for confirmation", matchPercentage: 95),
        SwapItem(id: "2", bookTitle: "Atomic Habits", requesterName: "Maya Sari", status: "Book sent", matchPercentage: 88),
        SwapItem(id: "3", bookTitle: "Norwegian Wood", requesterName: "James Wong", status: "Ready to swap", matchPercentage: 92)
    ]
    
    // MARK: - Data untuk Location
    let cities = ["Jakarta", "Surabaya", "Bandung", "Medan", "Semarang", "Yogyakarta", "Bali", "Makassar"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Header (Avatar & User Info)
                    VStack(spacing: 12) {
                        // Avatar - Menggunakan gambar Hahoh
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
                            
                            // MARK: - Location Row (Bisa Ganti Location)
                            HStack(spacing: 8) {
                                Image(systemName: "location.fill")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "809671"))
                                Text(selectedCity)
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "725C3A"))
                                Button(action: {
                                    showingLocationSheet = true
                                }) {
                                    Image(systemName: "chevron.down")
                                        .font(.caption2)
                                        .foregroundColor(Color(hex: "809671"))
                                }
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(.top, 20)
                    
                    // MARK: - Stats Row (Books Shared & Swaps Made)
                    HStack(spacing: 24) {
                        StatCard(value: "23", title: "Books Shared")
                        StatCard(value: "17", title: "Swaps Made")
                    }
                    .padding(.horizontal, 20)
                    
                    // MARK: - Ongoing Swaps Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Ongoing Swaps")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(hex: "725C3A"))
                            
                            Spacer()
                            
                            Text("\(ongoingSwaps.count) active")
                                .font(.caption)
                                .foregroundColor(Color(hex: "809671"))
                        }
                        .padding(.horizontal, 4)
                        
                        if ongoingSwaps.isEmpty {
                            HStack {
                                Spacer()
                                VStack(spacing: 8) {
                                    Image(systemName: "arrow.triangle.swap")
                                        .font(.largeTitle)
                                        .foregroundColor(Color(hex: "B3B792").opacity(0.5))
                                    Text("No active swaps")
                                        .font(.subheadline)
                                        .foregroundColor(Color(hex: "725C3A").opacity(0.6))
                                    Text("Start swapping books from Discover")
                                        .font(.caption)
                                        .foregroundColor(Color(hex: "725C3A").opacity(0.4))
                                }
                                Spacer()
                            }
                            .padding(.vertical, 20)
                        } else {
                            ForEach(ongoingSwaps) { swap in
                                OngoingSwapCard(swap: swap) {
                                    selectedSwap = swap
                                    showingMatchView = true
                                }
                            }
                        }
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
            .sheet(isPresented: $showingLocationSheet) {
                LocationSelectionSheet(selectedCity: $selectedCity, cities: cities)
            }
            .navigationDestination(isPresented: $showingMatchView) {
                MatchView()  // Tanpa parameter swapData
            }
        }
    }
}

// MARK: - Location Selection Sheet (Bisa Ganti Location)
struct LocationSelectionSheet: View {
    @Binding var selectedCity: String
    let cities: [String]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "E5E0D8").ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Select Your City")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "725C3A"))
                        .padding(.top, 24)
                    
                    Text("Choose your location to find nearby book swaps")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "725C3A").opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(cities, id: \.self) { city in
                                Button(action: {
                                    selectedCity = city
                                    dismiss()
                                }) {
                                    HStack {
                                        Image(systemName: city == selectedCity ? "location.circle.fill" : "location.circle")
                                            .foregroundColor(Color(hex: "809671"))
                                        Text(city)
                                            .foregroundColor(Color(hex: "725C3A"))
                                        Spacer()
                                        if city == selectedCity {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(Color(hex: "809671"))
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(hex: "B3B792").opacity(0.3), lineWidth: 1)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "809671"))
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

// MARK: - Ongoing Swap Card Component
struct OngoingSwapCard: View {
    let swap: SwapItem
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Book Cover Placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "D2AB80").opacity(0.3))
                        .frame(width: 60, height: 80)
                    Image(systemName: "book.closed.fill")
                        .font(.title2)
                        .foregroundColor(Color(hex: "809671"))
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(swap.bookTitle)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "725C3A"))
                    
                    Text("With: \(swap.requesterName)")
                        .font(.caption)
                        .foregroundColor(Color(hex: "725C3A").opacity(0.7))
                    
                    HStack(spacing: 8) {
                        // Status badge
                        Text(swap.status)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                Capsule()
                                    .fill(statusColor(swap.status).opacity(0.2))
                            )
                            .foregroundColor(statusColor(swap.status))
                        
                        // Match percentage
                        HStack(spacing: 4) {
                            Image(systemName: "heart.fill")
                                .font(.caption2)
                                .foregroundColor(Color(hex: "D2AB80"))
                            Text("\(swap.matchPercentage)% match")
                                .font(.caption2)
                                .foregroundColor(Color(hex: "725C3A").opacity(0.6))
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Color(hex: "B3B792"))
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color(hex: "725C3A").opacity(0.08), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func statusColor(_ status: String) -> Color {
        switch status {
        case "Waiting for confirmation":
            return Color(hex: "D2AB80")
        case "Book sent":
            return Color(hex: "809671")
        case "Ready to swap":
            return Color(hex: "B3B792")
        default:
            return Color(hex: "725C3A")
        }
    }
}

// MARK: - Swap Item Model
struct SwapItem: Identifiable {
    let id: String
    let bookTitle: String
    let requesterName: String
    let status: String
    let matchPercentage: Int
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
            DiscoveryView()
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

#Preview {
    MainTabView()
}
