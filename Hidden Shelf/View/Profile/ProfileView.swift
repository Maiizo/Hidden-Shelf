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
            // Gunakan DiscoveryView dari folder Discovery
            DiscoveryView()
                .tabItem {
                    Image(systemName: "safari")
                    Text("Discover")
                }
            
            // Gunakan MyShelfView dari folder MyShelf
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
