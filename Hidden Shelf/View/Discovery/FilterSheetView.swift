//
//  FilterSheetView.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import SwiftUI

struct FilterSheetView: View {
    @ObservedObject var viewModel: DiscoveryViewModel
    
    // Closure untuk memberi tahu DiscoveryView saat panel ini perlu ditutup
    var onClose: () -> Void = {}
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // Header: Sekarang bersih tanpa tombol silang internal ganda
            HStack {
                Text("Filters")
                    .font(.system(.title2, design: .serif).bold())
                    .foregroundColor(Theme.carob)
                Spacer()
            }
            .padding(.bottom, 5)
            
            // Form Dropdown Selector
            VStack(spacing: 15) {
                // Filter Genre
                VStack(alignment: .leading, spacing: 8) {
                    Text("Genre").font(.subheadline).foregroundColor(Theme.carob.opacity(0.7))
                    Picker("Select Genre", selection: $viewModel.selectedGenre) {
                        ForEach(viewModel.genres, id: \.self) { genre in
                            Text(genre).tag(genre)
                        }
                    }
                    .pickerStyle(.menu)
                    .accentColor(Theme.carob)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.almond, lineWidth: 1))
                }
                
                // Filter Batasan Halaman
                VStack(alignment: .leading, spacing: 8) {
                    Text("Page Count").font(.subheadline).foregroundColor(Theme.carob.opacity(0.7))
                    Picker("Select Page Count", selection: $viewModel.selectedPageCountRange) {
                        ForEach(viewModel.pageRanges, id: \.self) { range in
                            Text(range).tag(range)
                        }
                    }
                    .pickerStyle(.menu)
                    .accentColor(Theme.carob)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.almond, lineWidth: 1))
                }
                
                // Filter Regional Kota
                VStack(alignment: .leading, spacing: 8) {
                    Text("City Region").font(.subheadline).foregroundColor(Theme.carob.opacity(0.7))
                    Picker("Select City", selection: $viewModel.selectedCity) {
                        ForEach(viewModel.cities, id: \.self) { city in
                            Text(city).tag(city)
                        }
                    }
                    .pickerStyle(.menu)
                    .accentColor(Theme.carob)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.almond, lineWidth: 1))
                }
            }
            
            // Button Terapkan
            Button(action: {
                viewModel.applyFilters()
                // Memicu animasi penutupan panel di DiscoveryView
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    onClose()
                }
            }) {
                Text("Apply Filters")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Theme.matcha)
                    .cornerRadius(15)
                    .shadow(color: Theme.matcha.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .padding(.top, 10)
        }
        .padding(24)
        .background(Theme.vanilla)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 8)
    }
}

#Preview {
    FilterSheetView(viewModel: DiscoveryViewModel(), onClose: {})
        .padding()
}
