//
//  ProfileView.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    // MARK: - State Variables
    @State private var showingLocationSheet = false
    @State private var selectedCity = "Jakarta"
    @State private var showingMatchView = false
    @State private var selectedSwap: SwapItem? = nil
    @State private var isLoading = true
    
    // MARK: - User Data dari Firebase
    @State private var fullName = ""
    @State private var email = ""
    @State private var bio = ""
    @State private var userId = ""
    @State private var profileImageUrl = ""
    @State private var booksShared = 0
    @State private var swapsMade = 0
    
    // MARK: - Dummy Data untuk Ongoing Swaps (nanti bisa diambil dari Firestore)
    @State private var ongoingSwaps: [SwapItem] = []
    
    // MARK: - Data untuk Location
    let cities = ["Jakarta", "Surabaya", "Bandung", "Medan", "Semarang", "Yogyakarta", "Bali", "Makassar"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if isLoading {
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(Color(hex: "809671"))
                        Text("Loading profile...")
                            .foregroundColor(Color(hex: "725C3A"))
                    }
                    .frame(maxWidth: .infinity, minHeight: 500)
                } else {
                    VStack(spacing: 24) {
                        
                        // MARK: - Header (Avatar & User Info)
                        VStack(spacing: 12) {
                            // Avatar - Default atau dari URL
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "E5D2B8"))
                                    .frame(width: 90, height: 90)
                                
                                if profileImageUrl.isEmpty {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(Color(hex: "809671"))
                                } else {
                                    // AsyncImage untuk gambar dari URL
                                    AsyncImage(url: URL(string: profileImageUrl)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 90, height: 90)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                            .foregroundColor(Color(hex: "809671"))
                                    }
                                }
                            }
                            .overlay(
                                Circle()
                                    .stroke(Color(hex: "B3B792"), lineWidth: 2)
                            )
                            
                            VStack(spacing: 4) {
                                Text(fullName.isEmpty ? "User" : fullName)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hex: "725C3A"))
                                
                                Text(email)
                                    .font(.subheadline)
                                    .foregroundColor(Color(hex: "725C3A").opacity(0.7))
                                
                                // Bio
                                if !bio.isEmpty {
                                    Text(bio)
                                        .font(.caption)
                                        .foregroundColor(Color(hex: "725C3A").opacity(0.6))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 40)
                                        .padding(.top, 4)
                                }
                                
                                // MARK: - Location Row
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
                        
                        // MARK: - Stats Row (Books Shared & Swaps Made) - Data Real
                        HStack(spacing: 24) {
                            StatCard(value: "\(booksShared)", title: "Books Shared")
                            StatCard(value: "\(swapsMade)", title: "Swaps Made")
                        }
                        .padding(.horizontal, 20)
                        
                        // MARK: - Edit Profile Button
                        Button(action: {
                            // Navigasi ke Edit Profile
                            print("Edit Profile tapped")
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Edit Profile")
                            }
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color(hex: "809671"))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                        }
                        .padding(.horizontal, 60)
                        
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
                            
                            Divider()
                                .background(Color(hex: "B3B792").opacity(0.3))
                                .padding(.leading, 52)
                            
                            // Logout Button
                            Button(action: {
                                logoutUser()
                            }) {
                                HStack {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .foregroundColor(Color(hex: "D2AB80"))
                                        .frame(width: 28, height: 28)
                                    
                                    Text("Logout")
                                        .font(.body)
                                        .foregroundColor(Color(hex: "D2AB80"))
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(Color(hex: "B3B792"))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                            }
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
                            
                            SmallWidgetCard()
                            MediumWidgetCard()
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
            }
            .background(Color(hex: "E5E0D8"))
            .navigationBarHidden(true)
            .sheet(isPresented: $showingLocationSheet) {
                LocationSelectionSheet(selectedCity: $selectedCity, cities: cities)
            }
            .navigationDestination(isPresented: $showingMatchView) {
                MatchView()
            }
        }
        .onAppear {
            loadUserData()
        }
    }
    
    // MARK: - Load User Data dari Firebase
    private func loadUserData() {
        guard let currentUser = Auth.auth().currentUser else {
            isLoading = false
            return
        }
        
        userId = currentUser.uid
        email = currentUser.email ?? ""
        
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { document, error in
            isLoading = false
            
            if let error = error {
                print("❌ Error loading user data: \(error.localizedDescription)")
                return
            }
            
            if let data = document?.data() {
                fullName = data["fullName"] as? String ?? ""
                bio = data["bio"] as? String ?? ""
                profileImageUrl = data["profileImageUrl"] as? String ?? ""
                booksShared = data["booksShared"] as? Int ?? 0
                swapsMade = data["swapsMade"] as? Int ?? 0
                
                // Jika ada saved city
                if let savedCity = data["city"] as? String {
                    selectedCity = savedCity
                }
                
                print("✅ User data loaded: \(fullName)")
            }
        }
    }
    
    // MARK: - Logout
    private func logoutUser() {
        do {
            try Auth.auth().signOut()
            // Kembali ke LoginView
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = UIHostingController(rootView: LoginView())
                window.makeKeyAndVisible()
            }
        } catch {
            print("❌ Logout error: \(error.localizedDescription)")
        }
    }
}

// MARK: - Location Selection Sheet
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
                                    saveCityToFirestore(city)
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
    
    private func saveCityToFirestore(_ city: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("users").document(userId).updateData(["city": city]) { error in
            if let error = error {
                print("❌ Error saving city: \(error.localizedDescription)")
            } else {
                print("✅ City saved: \(city)")
            }
        }
    }
}

// MARK: - Ongoing Swap Card Component (Sama seperti sebelumnya)
struct OngoingSwapCard: View {
    let swap: SwapItem
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
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
                        Text(swap.status)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(statusColor(swap.status).opacity(0.2)))
                            .foregroundColor(statusColor(swap.status))
                        
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
        case "Waiting for confirmation": return Color(hex: "D2AB80")
        case "Book sent": return Color(hex: "809671")
        case "Ready to swap": return Color(hex: "B3B792")
        default: return Color(hex: "725C3A")
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

#Preview {
    ProfileView()
}
