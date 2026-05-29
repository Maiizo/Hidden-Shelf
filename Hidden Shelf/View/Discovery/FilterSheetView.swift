//
//  FilterSheetView.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import SwiftUI

struct FilterSheetView: View {
    @ObservedObject var viewModel: DiscoveryViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 25) {
                HStack {
                    Text("Filters")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Theme.carob)
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Theme.carob.opacity(0.5))
                            .font(.title3)
                    }
                }
                .padding(.bottom, 10)
                
                // Form Dropdown Selector
                VStack(spacing: 20) {
                    // Filter Genre
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Genre").font(.subheadline).foregroundColor(Theme.carob.opacity(0.7))
                        Picker("Select Genre", selection: $viewModel.selectedGenre) {
                            ForEach(viewModel.genres, id: \.self) { genre in
                                Text(genre).tag(genre)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Theme.almond.opacity(0.5))
                        .cornerRadius(12)
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Theme.almond.opacity(0.5))
                        .cornerRadius(12)
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Theme.almond.opacity(0.5))
                        .cornerRadius(12)
                    }
                }
                
                Spacer()
                
                // Button Terapkan
                Button(action: {
                    viewModel.applyFilters()
                    dismiss()
                }) {
                    Text("Apply Filters")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Theme.matcha)
                        .cornerRadius(15)
                }
            }
            .padding(24)
            .background(Theme.almond.opacity(0.2))
            .navigationBarHidden(true)
        }
    }
}
