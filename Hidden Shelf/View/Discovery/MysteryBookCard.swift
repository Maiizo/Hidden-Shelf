//
//  MysteryBookCard.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import SwiftUI

struct MysteryBookCard: View {
    var book: Book
    var onSkip: () -> Void
    var onRequestSwap: () -> Void
    
    var body: some View {
        VStack(spacing: 18) {
            // 1. HEADER CARD: Bersih tanpa maskot di kanan atas
            HStack {
                Image(systemName: "book")
                    .foregroundColor(Theme.matcha)
                Text("Mystery Book")
                    .font(.system(.subheadline, design: .serif))
                    .foregroundColor(Theme.carob.opacity(0.8))
                Spacer()
            }
            .padding(.horizontal, 5)
            
            // 2. KOTAK UTAMA: Maskot di Sisi Kiri & Quote di Sisi Kanan
            HStack(alignment: .center, spacing: 16) {
                // Gambar Maskot ditaruh di kiri quote dengan ukuran proporsional
                Image("Hahoh")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Isi Quote Section
                VStack(alignment: .leading, spacing: 4) {
                    Text("“")
                        .font(.system(size: 35, design: .serif))
                        .foregroundColor(Theme.chai)
                        .frame(height: 12)
                    
                    Text(book.quote)
                        .font(.system(.body, design: .serif))
                        .italic()
                        .foregroundColor(Theme.carob)
                        .lineSpacing(4)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 5)
                        // 👇 INI MANDALANYA: Memaksa teks memanjang ke bawah dan melarang pemotongan elipsis horizontal
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack {
                        Spacer()
                        Text("”")
                            .font(.system(size: 35, design: .serif))
                            .foregroundColor(Theme.chai)
                    }
                    .frame(height: 12)
                }
            }
            .padding(.vertical, 5)
            
            // 3. TAGS & BADGES (Genre & Halaman)
            HStack(spacing: 8) {
                // Genre Tag
                Text(book.genre)
                    .font(.caption)
                    .bold()
                    .padding(.vertical, 6)
                    .padding(.horizontal, 14)
                    .background(Theme.chai.opacity(0.4))
                    .cornerRadius(15)
                    .foregroundColor(Theme.carob)
                
                // Pages Tag (Dipaksa 1 Line Saja)
                HStack(spacing: 4) {
                    Image(systemName: "doc.text")
                        .font(.caption)
                    Text("\(book.pages) pages")
                        .font(.caption)
                        .lineLimit(1) // Memastikan teks halaman tetap 1 baris aman
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(Color.white.opacity(0.6))
                .cornerRadius(15)
                .foregroundColor(Theme.carob)
                
                Spacer()
            }
            .padding(.top, 5)
            
            // 4. PUBLISHER: Sekarang dipindah paling bawah sebelum tombol aksi
            HStack {
                Text("Published by: \(book.publisher)")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.carob.opacity(0.6))
                Spacer()
            }
            .padding(.horizontal, 5)
            .padding(.top, 2)
            
            // 5. ACTION BUTTONS (Skip & Request Swap)
            HStack(spacing: 15) {
                Button(action: onSkip) {
                    HStack {
                        Image(systemName: "xmark")
                        Text("Skip")
                    }
                    .font(.headline)
                    .foregroundColor(Theme.carob)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                }
                
                Button(action: onRequestSwap) {
                    HStack {
                        Image(systemName: "heart.fill")
                        Text("Request Swap")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Theme.matcha)
                    .cornerRadius(15)
                    .shadow(color: Theme.matcha.opacity(0.3), radius: 5, x: 0, y: 3)
                }
            }
            .padding(.top, 8)
        }
        .padding(24)
        .background(Theme.vanilla.opacity(0.3))
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Theme.almond, lineWidth: 1)
        )
    }
}

// Preview area tetap aman di baris akhir
#Preview {
    MysteryBookCard(
        book: Book(
            id: "dummy_1",
            title: "Mystery Novel",
            author: "Unknown author",
            genre: "Philosophy",
            pages: 320,
            publisher: "Vintage Books",
            quote: "In the depths of winter, I finally learned that within me there lay an invincible summer.",
            city: "Surabaya",
            isAvailable: true,
            ownerId: "dummy_owner"
        ),
        onSkip: {
            print("Tombol skip ditekan di preview")
        },
        onRequestSwap: {
            print("Tombol request swap ditekan di preview")
        }
    )
    .padding()
}
