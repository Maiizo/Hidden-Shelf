//
//  HiddenShelfWidget.swift
//  HiddenShelfWidget
//
//  Created by student on 29/05/26.
//

import WidgetKit
import SwiftUI

// Model data sederhana untuk Widget
struct WidgetBook {
    let id: String
    let quote: String
    let genre: String
    let mascotImageName: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), book: WidgetBook(
            id: "dummy_1",
            quote: "In the depths of winter, I finally learned that within me there lay an invincible summer.",
            genre: "Philosophy",
            mascotImageName: "Readingflip" // 👈 FIXED
        ))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), book: WidgetBook(
            id: "dummy_1",
            quote: "The measure of a man is what he does with power.",
            genre: "Philosophy",
            mascotImageName: "Readingflip" // 👈 FIXED
        ))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            var entries: [SimpleEntry] = []
            let currentDate = Date()
            
            // 💡 Membaca data dinamis akun aktif yang dikirim dari DiscoveryView via App Group
            if let sharedDefaults = UserDefaults(suiteName: "group.com.kamu.HiddenShelf"),
               let rawBooks = sharedDefaults.array(forKey: "topMysteryBooks") as? [[String: String]], !rawBooks.isEmpty {
                
                for (index, dict) in rawBooks.enumerated() {
                    // ⏱️ Membuat antrean: Buku ke-1 tayang sekarang, Buku ke-2 tayang +30 menit, dst.
                    guard let rilisDate = Calendar.current.date(byAdding: .minute, value: index * 30, to: currentDate) else { continue }
                    
                    let widgetBook = WidgetBook(
                        id: dict["id"] ?? "",
                        quote: dict["quote"] ?? "No Quote Found",
                        genre: dict["genre"] ?? "General",
                        mascotImageName: "Readingflip" // Proteksi dari crash ukuran gambar raksasa
                    )
                    
                    let entry = SimpleEntry(date: rilisDate, book: widgetBook)
                    entries.append(entry)
                    
                    // Batasi antrean timeline (misal maks 6 buku / 3 jam ke depan) agar menghemat baterai iPhone
                    if entries.count >= 6 { break }
                }
            }
            
            // Jaga-jaga jika data kosong (belum login / data belum ditarik dari network)
            if entries.isEmpty {
                let fallbackEntry = SimpleEntry(date: currentDate, book: WidgetBook(
                    id: "welcome_state",
                    quote: "Silakan buka aplikasi Hidden Shelf dan masuk ke akunmu untuk memuat kutipan buku hari ini.",
                    genre: "Discovery",
                    mascotImageName: "Readingflip"
                ))
                entries.append(fallbackEntry)
            }

            // Kebijakan .atEnd: Begitu seluruh antrean buku habis tayang, iOS otomatis men-trigger fungsi ini lagi untuk meminta data baru
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }

struct SimpleEntry: TimelineEntry {
    let date: Date
    let book: WidgetBook
}

struct HiddenShelfWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        HStack(spacing: 16) {
            
            // 1. Bagian Kiri: Maskot
            Image(entry.book.mascotImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)
                .padding(.leading, 4)
            
            // 2. Bagian Kanan: Petik, Quotes, Petik Bawah, & Genre
            VStack(alignment: .leading, spacing: 4) {
                
                // Ikon Petik Pembuka
                Text("“")
                    .font(.system(size: 28, design: .serif))
                    .foregroundColor(Color(Theme.carob).opacity(0.3))
                    .frame(height: 8)
                
                // Kutipan Buku (Quotes)
                Text(entry.book.quote)
                    .font(.system(size: 12, weight: .medium, design: .serif))
                    .italic()
                    .foregroundColor(Color(Theme.carob))
                    .multilineTextAlignment(.leading)
                    .lineLimit(3) // Batasi 3 baris agar ruang muat untuk komponen lain
                    .padding(.horizontal, 12)
                
                // Ikon Petik Penutup (FIXED: Sekarang muncul di kanan bawah teks)
                HStack {
                    Spacer()
                    Text("”")
                        .font(.system(size: 28, design: .serif))
                        .foregroundColor(Color(hex: "725C3A").opacity(0.3))
                        .frame(height: 8)
                }
                .padding(.trailing, 8)
                
                Spacer(minLength: 0)
                
                // Label Genre
                Text(entry.book.genre)
                    .font(.system(size: 9, weight: .bold))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 10)
                    .background(Color(hex: "809671").opacity(0.2))
                    .cornerRadius(8)
                    .foregroundColor(Color(hex: "725C3A"))
            }
        }
        .padding(14)
        .containerBackground(Color(hex: "F7F5F0"), for: .widget)
                .widgetURL(URL(string: "hiddenshelf://book/\(entry.book.id)")!)
    }
}

@main
struct HiddenShelfWidget: Widget {
    let kind: String = "HiddenShelfWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HiddenShelfWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Mystery Book")
        .description("Intip satu kutipan buku misteri hari ini.")
        .supportedFamilies([.systemMedium])
    }
}

// MARK: - PREVIEW AREA
#Preview(as: .systemMedium) {
    HiddenShelfWidget() // Menyambungkan langsung ke konfigurasi utama widget
} timeline: {
    SimpleEntry(
        date: Date(),
        book: WidgetBook(
            id: "preview_1",
            quote: "The measure of a man is what he does with power.",
            genre: "Philosophy",
            mascotImageName: "Readingflip"
        )
    )
    SimpleEntry(
        date: Date(),
        book: WidgetBook(
            id: "preview_2",
            quote: "In the depths of winter, I finally learned that within me there lay an invincible summer.",
            genre: "Classic",
            mascotImageName: "Readingflip"
        )
    )
}
