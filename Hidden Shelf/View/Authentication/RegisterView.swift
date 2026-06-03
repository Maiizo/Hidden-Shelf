//
//  RegisterView.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import SwiftUI

struct RegisterView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoggingIn = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(hex: "E5E0D8")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 28) {
                    // Header with Logo Reading
                    VStack(spacing: 12) {
                        // Logo Reading (sama seperti LoginView)
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
                        }
                        
                        // Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.caption)
                                .foregroundColor(Color(hex: "725C3A"))
                            SecureField("·············", text: $password)
                                .padding()
                                .background(Color(hex: "E5D2B8"))
                                .cornerRadius(16)
                                .foregroundColor(Color(hex: "725C3A"))
                        }
                        
                        // Confirm Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm Password")
                                .font(.caption)
                                .foregroundColor(Color(hex: "725C3A"))
                            SecureField("·············", text: $confirmPassword)
                                .padding()
                                .background(Color(hex: "E5D2B8"))
                                .cornerRadius(16)
                                .foregroundColor(Color(hex: "725C3A"))
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Create Account Button
                    Button(action: {
                        // Handle registration
                        print("Create Account tapped")
                    }) {
                        Text("Create Account")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "809671"))
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
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
    }
}

#Preview {
    RegisterView()
}
