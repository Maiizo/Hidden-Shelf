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

                // Background color

                Color(hex: "E5E0D8")

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

                                TextField("your @email.com", text: $email)

                                    .padding()

                                    .background(Color(hex: "E5D2B8"))

                                    .cornerRadius(16)

                                    .foregroundColor(Color(hex: "725C3A"))

                                    .textInputAutocapitalization(.never)

                                    .keyboardType(.emailAddress)

                            }

                            

                            // Password Field

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

                                .background(Color(hex: "809671"))

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

        }

    }

}



#Preview {

    LoginView()

}

