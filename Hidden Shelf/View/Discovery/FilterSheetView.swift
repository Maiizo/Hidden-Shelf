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
        VStack(alignment: .leading, spacing: 16) {
            
            // Header
            HStack {
                Text("Filters")
                    .font(.system(size: 16, weight: .bold, design: .serif))
                    .foregroundColor(Theme.carob)
                Spacer()
            }
            
            // Form Dropdown Selector (Style disamakan dengan MyShelfView)
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    DiscoveryFilterDropdownMenu(
                        label: "Genre",
                        selection: $viewModel.selectedGenre,
                        options: viewModel.genres
                    )
                    DiscoveryFilterDropdownMenu(
                        label: "Page Count",
                        selection: $viewModel.selectedPageCountRange,
                        options: viewModel.pageRanges
                    )
                }
                
                DiscoveryFilterDropdownMenu(
                    label: "City Region",
                    selection: $viewModel.selectedCity,
                    options: viewModel.cities
                )
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
                    .font(.system(.subheadline, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .background(Theme.matcha)
                    .cornerRadius(10)
                    .shadow(color: Theme.matcha.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(Theme.vanilla)
        .cornerRadius(16)
        .shadow(color: Theme.carob.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}

// Komponen Reusable khusus untuk Discovery, meng-copy style persis dari MyShelfView
struct DiscoveryFilterDropdownMenu: View {
    let label: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 10, weight: .bold, design: .serif))
                .foregroundColor(Theme.carob)
            
            Menu {
                Picker(label, selection: $selection) {
                    ForEach(options, id: \.self) { opt in Text(opt).tag(opt) }
                }
            } label: {
                HStack {
                    Text(selection)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    Spacer(minLength: 4)
                    
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 10))
                }
                .font(.system(size: 13, weight: .medium, design: .serif))
                .foregroundColor(Theme.carob)
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity, minHeight: 30)
                .background(Theme.almond)
                .cornerRadius(6)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    FilterSheetView(viewModel: DiscoveryViewModel(), onClose: {})
        .padding()
}
