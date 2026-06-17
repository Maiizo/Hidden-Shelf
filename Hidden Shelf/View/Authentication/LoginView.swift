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
    @State private var showPassword = false
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color(hex: "E5E0D8")
                    .ignoresSafeArea()
                    .onTapGesture {
                        // Menutup keyboard saat tap di luar
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
                                    .autocorrectionDisabled(true)
                            }
                            
                            // Password Field - dengan toggle visibility
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "725C3A"))
                                
                                HStack {
                                    if showPassword {
                                        TextField("Enter your password", text: $password)
                                            .padding()
                                            .foregroundColor(Color(hex: "725C3A"))
                                            .autocapitalization(.none)
                                            .autocorrectionDisabled(true)
                                    } else {
                                        SecureField("Enter your password", text: $password)
                                            .padding()
                                            .foregroundColor(Color(hex: "725C3A"))
                                    }
                                    
                                    Button(action: {
                                        showPassword.toggle()
                                    }) {
                                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                            .foregroundColor(Color(hex: "809671"))
                                            .padding(.trailing, 12)
                                    }
                                }
                                .background(Color(hex: "E5D2B8"))
                                .cornerRadius(16)
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Error message
                        if showError {
                            HStack {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.caption)
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, -8)
                        }
                        
                        // Login Button
                        Button(action: {
                            loginUser()
                        }) {
                            ZStack {
                                Text("Login")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        isFormValid
                                        ? Color(hex: "809671")
                                        : Color(hex: "809671").opacity(0.5)
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(16)
                                    .opacity(isLoading ? 0 : 1)
                                
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color(hex: "809671"))
                                        .cornerRadius(16)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .disabled(!isFormValid || isLoading)
                        
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
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationDestination(isPresented: $isRegistering) {
                RegisterView()
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                MainTabView()
            }
        }
    }
    
    // MARK: - Form Validation
    var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    // MARK: - Login ke Firebase
    private func loginUser() {
        isLoading = true
        errorMessage = ""
        showError = false
        
        // Validasi email format
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        guard emailPredicate.evaluate(with: email) else {
            errorMessage = "Please enter a valid email address"
            showError = true
            isLoading = false
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            showError = true
            isLoading = false
            return
        }
        
        // Login dengan Firebase Authentication
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    // Handle error yang lebih user-friendly
                    let nsError = error as NSError
                    if let errorCode = AuthErrorCode(rawValue: nsError.code) {
                        switch errorCode {
                        case .wrongPassword:
                            errorMessage = "Incorrect password. Please try again."
                        case .invalidEmail:
                            errorMessage = "Invalid email format."
                        case .userNotFound:
                            errorMessage = "No account found with this email. Please register first."
                        case .networkError:
                            errorMessage = "Network error. Please check your connection."
                        default:
                            errorMessage = error.localizedDescription
                        }
                    } else {
                        errorMessage = error.localizedDescription
                    }
                    showError = true
                } else {
                    // Login sukses
                    print("Login successful for user: \(email)")
                    isLoggedIn = true  // ← Ini yang benar, set ke true, bukan MainTabView()
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
