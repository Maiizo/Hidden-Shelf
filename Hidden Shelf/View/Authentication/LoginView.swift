//
//  LoginView.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistering = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color - menggunakan Theme
                Theme.almond
                    .ignoresSafeArea()
                
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
                                .foregroundColor(Theme.carob)
                            
                            Text("Discover your next mystery read")
                                .font(.subheadline)
                                .foregroundColor(Theme.carob.opacity(0.7))
                        }
                        
                        // Input fields
                        VStack(spacing: 20) {
                            // Email Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(.caption)
                                    .foregroundColor(Theme.carob)
                                TextField("your @email.com", text: $email)
                                    .padding()
                                    .background(Theme.vanilla)
                                    .cornerRadius(16)
                                    .foregroundColor(Theme.carob)
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.emailAddress)
                            }
                            
                            // Password Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(.caption)
                                    .foregroundColor(Theme.carob)
                                SecureField("·············", text: $password)
                                    .padding()
                                    .background(Theme.vanilla)
                                    .cornerRadius(16)
                                    .foregroundColor(Theme.carob)
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Login Button
                        Button(action: {
                            // Handle login action
                            print("Login tapped")
                        }) {
                            Text("Login")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.matcha)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                        .padding(.horizontal, 24)
                        
                        // Register link
                        Button(action: {
                            isRegistering = true
                        }) {
                            Text("Register a new account")
                                .font(.subheadline)
                                .foregroundColor(Theme.chai)
                                .underline()
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationDestination(isPresented: $isRegistering) {
                RegisterView()
            }
        }
    }
}

#Preview {
    LoginView()
}

