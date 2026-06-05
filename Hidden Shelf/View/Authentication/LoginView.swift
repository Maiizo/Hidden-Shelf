//
//  LoginView.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistering = false
    @State private var isLoggedIn = false
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color(hex: "E5E0D8")
                    .ignoresSafeArea()
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Logo & Title
                        VStack(spacing: 12) {
                            // Gambar reading.png sebagai logo
                            Image("Reading")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .padding(.top, 40)
                            
                            Text("Hidden Shelf")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: "725C3A"))
                            
                            Text("Discover your next mystery read")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "725C3A").opacity(0.7))
                        }
                        
                        // Input fields
                        VStack(spacing: 20) {
                            // Email Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "725C3A"))
                                TextField("your@email.com", text: $email)
                                    .padding()
                                    .background(Color(hex: "E5D2B8"))
                                    .cornerRadius(16)
                                    .foregroundColor(Color(hex: "725C3A"))
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.emailAddress)
                                    .autocorrectionDisabled()
                            }
                            
                            // Password Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "725C3A"))
                                SecureField("Enter password", text: $password)
                                    .padding()
                                    .background(Color(hex: "E5D2B8"))
                                    .cornerRadius(16)
                                    .foregroundColor(Color(hex: "725C3A"))
                                    .textContentType(.password)
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Login Button
                        Button(action: {
                            loginUser()
                        }) {
                            ZStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Login")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "809671"))
                            .foregroundColor(.white)
                            .cornerRadius(16)
                        }
                        .disabled(isLoading)
                        .padding(.horizontal, 24)
                        
                        // Register link
                        Button(action: {
                            isRegistering = true
                        }) {
                            Text("Register a new account")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "D2AB80"))
                                .underline()
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationDestination(isPresented: $isRegistering) {
                RegisterView()
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                ProfileView()
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    // MARK: - Login ke Firebase
    private func loginUser() {
        // Validasi input
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Please enter your email"
            showAlert = true
            return
        }
        
        guard !password.isEmpty else {
            alertMessage = "Please enter your password"
            showAlert = true
            return
        }
        
        isLoading = true
        
        print("📧 Attempting login with email: \(email)")
        
        // Sign in dengan Firebase Auth
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false
            
            if let error = error {
                let nsError = error as NSError
                print("❌ Login error: \(nsError.code) - \(error.localizedDescription)")
                
                // User-friendly error messages
                switch nsError.code {
                case 17011:
                    alertMessage = "No account found with this email. Please register first."
                case 17009:
                    alertMessage = "Incorrect password. Please try again."
                case 17020:
                    alertMessage = "Network error. Please check your connection."
                default:
                    alertMessage = error.localizedDescription
                }
                showAlert = true
                return
            }
            
            print("✅ Login successful for user: \(result?.user.email ?? "")")
            
            // Login berhasil, redirect ke ProfileView
            isLoggedIn = true
        }
    }
}

#Preview {
    LoginView()
}
