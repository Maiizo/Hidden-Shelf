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
        VStack(spacing: 20) {
            // Header Card
            HStack {
                Image(systemName: "book")
                    .foregroundColor(Theme.matcha)
                Text("Mystery Book")
                    .font(.system(.subheadline, design: .serif))
                    .foregroundColor(Theme.carob.opacity(0.8))
                Spacer()
                // Tempat meletakkan maskot imut di pojok kanan atas kartu (Menggunakan Dummy)
                Image("dummy_mascot_mini")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
            }
            .padding(.horizontal, 5)
            
            // Quote Section
            VStack(alignment: .leading, spacing: 8) {
                Text("“")
                    .font(.system(size: 40, design: .serif))
                    .foregroundColor(Theme.chai)
                    .frame(height: 15)
                
                Text(book.quote)
                    .font(.system(.body, design: .serif))
                    .italic()
                    .foregroundColor(Theme.carob)
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 10)
                
                HStack {
                    Spacer()
                    Text("”")
                        .font(.system(size: 40, design: .serif))
                        .foregroundColor(Theme.chai)
                }
                .frame(height: 15)
            }
            
            // Tags/Badges info (Genre, Halaman, Penerbit)
            HStack(spacing: 8) {
                Text(book.genre)
                    .font(.caption)
                    .bold()
                    .padding(.vertical, 6)
                    .padding(.horizontal, 14)
                    .background(Theme.chai.opacity(0.4))
                    .cornerRadius(15)
                    .foregroundColor(Theme.carob)
                
                HStack(spacing: 4) {
                    Image(systemName: "doc.text")
                        .font(.caption)
                    Text("\(book.pages) pages")
                        .font(.caption)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(Color.white.opacity(0.6))
                .cornerRadius(15)
                .foregroundColor(Theme.carob)
                
                Text(book.publisher)
                    .font(.caption)
                    .foregroundColor(Theme.carob.opacity(0.7))
                
                Spacer()
            }
            .padding(.top, 10)
            
            // Action Buttons (Skip & Request Swap)
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
            .padding(.top, 10)
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
