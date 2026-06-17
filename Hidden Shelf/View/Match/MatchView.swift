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
    @Environment(\.dismiss) var dismiss
    
    // Masukkan ID Match asli dari Firebase nanti di sini saat memanggil View ini
    var matchIdToLoad: String?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.almond.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    HStack {
                                    Button(action: {
                                        dismiss() 
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .font(.title2)
                                            .foregroundColor(.primary)
                                    }
                                    .padding()
                                    Spacer()
                                }
                    if viewModel.currentMatch != nil {
                        
                        // 🌍 PETA ADAPTIF
                        if #available(iOS 17.0, *) {
                            Map(initialPosition: .region(viewModel.region)) {
                                Marker("Meeting Point", coordinate: viewModel.region.center)
                                    .tint(Theme.matcha)
                            }
                            .frame(height: UIScreen.main.bounds.height * 0.40)
                        } else {
                            Map(coordinateRegion: $viewModel.region, annotationItems: [viewModel.currentMatch!]) { location in
                                MapMarker(coordinate: location.coordinate, tint: Theme.matcha)
                            }
                            .frame(height: UIScreen.main.bounds.height * 0.40)
                        }
                        
                        // 💡 PERUBAHAN: TRACKER DUA SISI
                        VStack(spacing: 16) {
                            Text("Book Swap Progress")
                                .font(.system(.headline, design: .serif))
                                .foregroundColor(Theme.carob)
                                .padding(.top, 10)
                            
                            // 1. Status Kamu
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Your Progress")
                                    .font(.system(.caption, design: .serif))
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.carob)
                                HStack(spacing: 10) {
                                    StepIndicator(title: "On the Way", isActive: viewModel.myStatusStep >= 0)
                                    StepIndicator(title: "Arrived", isActive: viewModel.myStatusStep >= 1)
                                    StepIndicator(title: "Complete", isActive: viewModel.myStatusStep >= 2)
                                }
                            }
                            
                            // 2. Status Partner
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Partner's Progress")
                                    .font(.system(.caption, design: .serif))
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.carob)
                                HStack(spacing: 10) {
                                    StepIndicator(title: "On the Way", isActive: viewModel.partnerStatusStep >= 0)
                                    StepIndicator(title: "Arrived", isActive: viewModel.partnerStatusStep >= 1)
                                    StepIndicator(title: "Complete", isActive: viewModel.partnerStatusStep >= 2)
                                }
                            }
                            
                            // 3. Tombol Aksi Dinamis
                            if viewModel.myStatusStep < 2 {
                                Button(action: {
                                    viewModel.nextStep()
                                }) {
                                    Text(viewModel.myStatusStep == 0 ? "I have Arrived" : "Finish Swapping")
                                        .font(.system(.body, design: .serif))
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Theme.matcha)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .padding(.top, 5)
                            } else {
                                // Tampilan saat kamu sudah selesai
                                Text(viewModel.partnerStatusStep < 2 ? "Waiting for partner to finish..." : "Swap Successfully Completed! 🎉")
                                    .font(.system(.subheadline, design: .serif))
                                    .fontWeight(.semibold)
                                    .foregroundColor(viewModel.partnerStatusStep < 2 ? Theme.carob.opacity(0.7) : Theme.matcha)
                                    .padding(.top, 10)
                            }
                        }
                        .padding()
                        .background(Theme.vanilla)
                        .cornerRadius(20)
                        .shadow(color: Theme.carob.opacity(0.1), radius: 5)
                        .offset(y: -20)
                        
                        // In MatchView body, replace the else branch:
                        } else {
                            ZStack {
                                Theme.almond.ignoresSafeArea()   // ← add this so it's not white
                                VStack(spacing: 16) {
                                    ProgressView()
                                        .scaleEffect(1.5)
                                        .tint(Theme.matcha)
                                    Text("Loading Meeting Point...")
                                        .font(.system(.title3, design: .serif))
                                        .foregroundColor(Theme.carob)
                                }
                            } .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                       
                    }
                }
            }
            .navigationTitle("Titik Temu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left").fontWeight(.bold)
                            Text("Kembali")
                        }
                        .foregroundColor(Theme.carob)
                    }
                }
            }
            .onAppear {
                // Jalankan Listener saat layar terbuka
                if let matchId = matchIdToLoad {
                    viewModel.listenToMatch(matchId: matchId)
                }
            }
            .alert("Confirm Swap Completion", isPresented: $viewModel.showConfirmationPopup) {
                Button("Yes, Swap Complete", role: .none) { viewModel.completeSwap() }
                Button("Not Yet", role: .cancel) { viewModel.resetSwap() }
            } message: {
                Text("Apakah proses serah terima buku fisik sudah selesai dilakukan bersama partner Anda?")
            }
        }
    }

// Helper View tetap sama
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

#Preview{
    MatchView()
}
