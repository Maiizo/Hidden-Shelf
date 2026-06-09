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
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showError = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(hex: "E5E0D8")
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            
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
                            TextField("your@email.com", text: $email)
                                .padding()
                                .background(Color(hex: "E5D2B8"))
                                .cornerRadius(16)
                                .foregroundColor(Color(hex: "725C3A"))
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled(true)
                        }
                        
                        // Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.caption)
                                .foregroundColor(Color(hex: "725C3A"))
                            
                            HStack {
                                if showPassword {
                                    TextField("Enter password", text: $password)
                                        .padding()
                                        .foregroundColor(Color(hex: "725C3A"))
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled(true)
                                } else {
                                    SecureField("Enter password", text: $password)
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
                        
                        // Confirm Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm Password")
                                .font(.caption)
                                .foregroundColor(Color(hex: "725C3A"))
                            
                            HStack {
                                if showConfirmPassword {
                                    TextField("Confirm password", text: $confirmPassword)
                                        .padding()
                                        .foregroundColor(Color(hex: "725C3A"))
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled(true)
                                } else {
                                    SecureField("Confirm password", text: $confirmPassword)
                                        .padding()
                                        .foregroundColor(Color(hex: "725C3A"))
                                }
                                
                                Button(action: {
                                    showConfirmPassword.toggle()
                                }) {
                                    Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(Color(hex: "809671"))
                                        .padding(.trailing, 12)
                                }
                            }
                            .background(Color(hex: "E5D2B8"))
                            .cornerRadius(16)
                        }
                        
                        // Password match indicator
                        if !confirmPassword.isEmpty && password != confirmPassword {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.caption2)
                                    .foregroundColor(.red)
                                Text("Passwords do not match")
                                    .font(.caption2)
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            .padding(.horizontal, 4)
                            .padding(.top, -8)
                        } else if !confirmPassword.isEmpty && password == confirmPassword {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.caption2)
                                    .foregroundColor(Color(hex: "809671"))
                                Text("Passwords match")
                                    .font(.caption2)
                                    .foregroundColor(Color(hex: "809671"))
                                Spacer()
                            }
                            .padding(.horizontal, 4)
                            .padding(.top, -8)
                        }
                        
                        // Error message
                        if showError {
                            HStack {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Create Account Button
                    Button(action: {
                        registerUser()
                    }) {
                        ZStack {
                            Text("Create Account")
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
            .scrollDismissesKeyboard(.interactively)
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
    }
    
    // MARK: - Form Validation
    var isFormValid: Bool {
        !fullName.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        password == confirmPassword &&
        password.count >= 6
    }
    
    // MARK: - Register User ke Firebase
    private func registerUser() {
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
        
        // 1. Create user with Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                    self.isLoading = false
                }
                return
            }
            
            guard let userId = authResult?.user.uid else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to create user account"
                    self.showError = true
                    self.isLoading = false
                }
                return
            }
            
            // 2. Save user data to Firestore
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "id": userId,
                "fullName": self.fullName,
                "email": self.email,
                "createdAt": Timestamp(date: Date()),
                "booksShared": 0,
                "swapsMade": 0,
                "city": "",
                "avatar": ""
            ]
            
            db.collection("users").document(userId).setData(userData) { error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        self.errorMessage = "Failed to save user data: \(error.localizedDescription)"
                        self.showError = true
                    } else {
                        // Registrasi berhasil, tutup halaman register
                        self.dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}
