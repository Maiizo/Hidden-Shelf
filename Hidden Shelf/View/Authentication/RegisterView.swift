//
//  RegisterView.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegisterView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isRegistered = false
    @Environment(\.dismiss) var dismiss
    
    // Tambahkan state variables untuk toggle password visibility
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "E5E0D8")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 28) {
                        // Header with Logo Reading
                        VStack(spacing: 12) {
                            Image("Lamp")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding(.top, 20)
                            
                            Text("Join Hidden Shelf")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: "725C3A"))
                            
                            Text("Start your sustainable reading journey")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "725C3A").opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        // Form Fields
                        VStack(spacing: 20) {
                            // Full Name
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Full Name")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "725C3A"))
                                TextField("Jane Doe", text: $fullName)
                                    .padding()
                                    .background(Color(hex: "E5D2B8"))
                                    .cornerRadius(16)
                                    .foregroundColor(Color(hex: "725C3A"))
                                    .autocapitalization(.words)
                            }
                            
                            // Email
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "725C3A"))
                                TextField("your @email.com", text: $email)
                                    .padding()
                                    .background(Color(hex: "E5D2B8"))
                                    .cornerRadius(16)
                                    .foregroundColor(Color(hex: "725C3A"))
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.emailAddress)
                                    .autocorrectionDisabled()
                            }
                            
                            // Password
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "725C3A"))
                                
                                HStack {
                                    if showPassword {
                                        TextField("Enter password", text: $password)
                                            .textContentType(.newPassword)
                                    } else {
                                        SecureField("Enter password", text: $password)
                                            .textContentType(.newPassword)
                                    }
                                    
                                    Button(action: {
                                        showPassword.toggle()
                                    }) {
                                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                            .foregroundColor(Color(hex: "725C3A"))
                                    }
                                }
                                .padding()
                                .background(Color(hex: "E5D2B8"))
                                .cornerRadius(16)
                            }
                            
                            // Confirm Password
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Confirm Password")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "725C3A"))
                                
                                HStack {
                                    if showConfirmPassword {
                                        TextField("Confirm your password", text: $confirmPassword)
                                            .textContentType(.newPassword)
                                    } else {
                                        SecureField("Confirm your password", text: $confirmPassword)
                                            .textContentType(.newPassword)
                                    }
                                    
                                    Button(action: {
                                        showConfirmPassword.toggle()
                                    }) {
                                        Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                            .foregroundColor(Color(hex: "725C3A"))
                                    }
                                }
                                .padding()
                                .background(Color(hex: "E5D2B8"))
                                .cornerRadius(16)
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Create Account Button
                        Button(action: {
                            registerUser()
                        }) {
                            ZStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Create Account")
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
                        
                        // Login link
                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(Color(hex: "725C3A").opacity(0.7))
                            Button(action: {
                                dismiss()
                            }) {
                                Text("Login")
                                    .foregroundColor(Color(hex: "D2AB80"))
                                    .underline()
                            }
                        }
                        .font(.subheadline)
                        
                        // Sustainability message
                        HStack(spacing: 8) {
                            Image(systemName: "leaf.arrow.circlepath")
                                .foregroundColor(Color(hex: "809671"))
                            Text("By joining, you're helping reduce paper waste and supporting SDG 11 & 12")
                                .font(.caption2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(hex: "725C3A").opacity(0.6))
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 8)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(hex: "809671"))
                        Text("Back")
                            .foregroundColor(Color(hex: "809671"))
                    }
                }
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .navigationDestination(isPresented: $isRegistered) {
                LoginView()
            }
        }
    }
    
    // MARK: - Register User ke Firebase (DENGAN ERROR DETAIL)
    private func registerUser() {
        // 1. Validasi Input
        guard !fullName.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Please enter your full name"
            showAlert = true
            return
        }
        
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Please enter your email"
            showAlert = true
            return
        }
        
        guard email.contains("@") && email.contains(".") else {
            alertMessage = "Please enter a valid email address"
            showAlert = true
            return
        }
        
        guard !password.isEmpty else {
            alertMessage = "Please enter a password"
            showAlert = true
            return
        }
        
        guard password.count >= 6 else {
            alertMessage = "Password must be at least 6 characters"
            showAlert = true
            return
        }
        
        guard password == confirmPassword else {
            alertMessage = "Passwords do not match"
            showAlert = true
            return
        }
        
        isLoading = true
        
        print("📧 Attempting to register user with email: \(email)")
        
        // 2. Buat user di Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                isLoading = false
                
                // PRINT DETAIL ERROR KE CONSOLE
                let nsError = error as NSError
                print("❌❌❌ FIREBASE AUTH ERROR ❌❌❌")
                print("🔴 Error Code: \(nsError.code)")
                print("🔴 Error Domain: \(nsError.domain)")
                print("🔴 Error Message: \(error.localizedDescription)")
                print("🔴 Full Error Details: \(nsError.userInfo)")
                
                // Tampilkan pesan error yang lebih user-friendly
                var userFriendlyMessage = ""
                switch nsError.code {
                case 17007:
                    userFriendlyMessage = "This email is already registered. Please login instead."
                case 17008:
                    userFriendlyMessage = "Please enter a valid email address."
                case 17009:
                    userFriendlyMessage = "Password is incorrect or invalid."
                case 17020:
                    userFriendlyMessage = "Network error. Please check your internet connection."
                case 17026:
                    userFriendlyMessage = "Password must be at least 6 characters."
                default:
                    userFriendlyMessage = error.localizedDescription
                }
                
                alertMessage = userFriendlyMessage
                showAlert = true
                return
            }
            
            guard let userId = result?.user.uid else {
                isLoading = false
                alertMessage = "Failed to create account. Please try again."
                showAlert = true
                return
            }
            
            print("✅ User created successfully with UID: \(userId)")
            
            // 3. Simpan data tambahan ke Firestore
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "fullName": fullName,
                "email": email.lowercased(),
                "createdAt": Timestamp(date: Date()),
                "userId": userId,
                "profileImageUrl": "",
                "bio": "",
                "favoriteGenres": []
            ]
            
            db.collection("users").document(userId).setData(userData) { error in
                isLoading = false
                
                if let error = error {
                    print("❌ Firestore error: \(error.localizedDescription)")
                    alertMessage = "Account created but failed to save profile: \(error.localizedDescription)"
                    showAlert = true
                } else {
                    print("✅ User data saved to Firestore successfully!")
                    // Register sukses
                    isRegistered = true
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}
