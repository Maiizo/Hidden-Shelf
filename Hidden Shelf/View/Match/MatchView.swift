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
    
    // 💡 TAMBAHAN: Environment untuk menutup halaman
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.almond.ignoresSafeArea() // Latar Themed
                
                VStack(spacing: 0) {
                    if let match = viewModel.currentMatch {
                        
                        // 🌍 PETA ADAPTIF (Bebas Warning)
                        if #available(iOS 17.0, *) {
                            Map(initialPosition: .region(viewModel.region)) {
                                Marker("Meeting Point", coordinate: match.coordinate)
                                    .tint(Theme.matcha)
                            }
                            .frame(height: UIScreen.main.bounds.height * 0.45)
                        } else {
                            Map(coordinateRegion: $viewModel.region, annotationItems: [match]) { location in
                                MapMarker(coordinate: location.coordinate, tint: Theme.matcha)
                            }
                            .frame(height: UIScreen.main.bounds.height * 0.45)
                        }
                        
                        // STATUS TRACKER
                        VStack(spacing: 20) {
                            Text("Book Swap Progress")
                                .font(.system(.headline, design: .serif))
                                .foregroundColor(Theme.carob)
                                .padding(.top)
                            
                            HStack(spacing: 10) {
                                StepIndicator(title: "On the Way", isActive: viewModel.statusStep >= 0)
                                StepIndicator(title: "Arrived", isActive: viewModel.statusStep >= 1)
                                StepIndicator(title: "Complete", isActive: viewModel.statusStep >= 2)
                            }
                            .padding(.horizontal)
                            
                            Text("Current Status: \(match.status)")
                                .font(.system(.subheadline, design: .serif))
                                .foregroundColor(Theme.carob.opacity(0.8))
                            
                            // TOMBOL AKSI
                            if viewModel.statusStep < 2 {
                                Button(action: {
                                    viewModel.nextStep()
                                }) {
                                    Text(viewModel.statusStep == 0 ? "I have Arrived" : "Finish Swapping")
                                        .font(.system(.body, design: .serif))
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Theme.matcha)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding()
                        .background(Theme.vanilla)
                        .cornerRadius(20)
                        .shadow(color: Theme.carob.opacity(0.1), radius: 5)
                        .offset(y: -20)
                        
                    } else {
                        // STANDARDIZED FALLBACK
                        VStack(spacing: 16) {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.system(size: 50))
                                .foregroundColor(Theme.carob.opacity(0.5))
                            Text("No Active Match")
                                .font(.system(.title2, design: .serif))
                                .fontWeight(.semibold)
                                .foregroundColor(Theme.carob)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .navigationTitle("Titik Temu")
            .navigationBarTitleDisplayMode(.inline)
            
            // 💡 TAMBAHAN: Tombol Back Kustom
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss() // Menutup layar MatchView
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .fontWeight(.bold)
                            Text("Kembali")
                        }
                        .foregroundColor(Theme.carob)
                    }
                }
            }
            
            // ALERT POP-UP KONFIRMASI
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

// Helper View
struct StepIndicator: View {
    let title: String
    let isActive: Bool
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(isActive ? Theme.matcha : Theme.carob.opacity(0.2))
                .frame(height: 6)
                .cornerRadius(3)
            Text(title)
                .font(.system(.caption2, design: .serif))
                .foregroundColor(isActive ? Theme.carob : Theme.carob.opacity(0.6))
        }
    }
}

#Preview
{
    MatchView()
}
