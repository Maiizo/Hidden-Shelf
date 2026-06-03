//
//  ContentView.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import SwiftUI

struct ContentView: View {
    // State untuk menyimpan tab mana yang sedang aktif.
    // Nilai default 0 memastikan tab dengan tag(0) terbuka duluan (Discovery).
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Discovery (Landing Page)
            DiscoveryView()
                .tabItem {
                    Label("Discovery", systemImage: "magnifyingglass")
                }
                .tag(0)
            
            // Tab 2: My Shelf
            MyShelfView()
                .tabItem {
                    Label("My Shelf", systemImage: "books.vertical.fill")
                }
                .tag(1)
        }
        // Opsional: Mewarnai ikon tab yang aktif pakai warna Theme kamu biar senada!
        .accentColor(Theme.carob)
    }
}

#Preview {
    ContentView()
}
