//
//  MatchView.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//
// MatchView.swift
import SwiftUI
import MapKit

struct MatchView: View {
    @StateObject private var viewModel = MatchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if let match = viewModel.currentMatch {
                    
                    // 1. Modern iOS 17 Map Component
                    Map(position: $viewModel.cameraPosition) {
                        Marker("Meeting Point", coordinate: match.coordinate)
                            .tint(.blue)
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.45)
                    
                    // 2. The Status Tracker
                    VStack(spacing: 20) {
                        Text("Book Swap Progress")
                            .font(.headline)
                            .padding(.top)
                        
                        HStack(spacing: 10) {
                            StepIndicator(title: "On the Way", isActive: viewModel.statusStep >= 0)
                            StepIndicator(title: "Arrived", isActive: viewModel.statusStep >= 1)
                            StepIndicator(title: "Complete", isActive: viewModel.statusStep >= 2)
                        }
                        .padding(.horizontal)
                        
                        Text("Current Status: \(match.status)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        // 3. Dynamic Action Button
                        if viewModel.statusStep < 2 {
                            Button(action: {
                                viewModel.nextStep()
                            }) {
                                Text(viewModel.statusStep == 0 ? "I have Arrived" : "Finish Swapping")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .offset(y: -20)
                    
                } else {
                    ContentUnavailableView("No Active Match", systemImage: "clock.arrow.circlepath")
                }
            }
            .navigationTitle("Titik Temu")
            .navigationBarTitleDisplayMode(.inline)
            
            // 4. The Required Confirmation Alert
            .alert("Confirm Swap Completion", isPresented: $viewModel.showConfirmationPopup) {
                Button("Yes, Swap Complete", role: .none) {
                    viewModel.completeSwap()
                }
                Button("Not Yet", role: .cancel) {
                    viewModel.resetSwap()
                }
            } message: {
                Text("Apakah proses serah terima buku fisik sudah selesai dilakukan bersama partner Anda?")
            }
        }
    }
}

// Helper View for the Tracker
struct StepIndicator: View {
    let title: String
    let isActive: Bool
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(isActive ? Color.blue : Color.gray.opacity(0.3))
                .frame(height: 6)
                .cornerRadius(3)
            Text(title)
                .font(.caption2)
                .foregroundColor(isActive ? .primary : .secondary)
        }
    }
}

#Preview {
    MatchView()
}

