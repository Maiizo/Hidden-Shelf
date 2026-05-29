//
//  HiddenShelfWidget.swift
//  HiddenShelfWidget
//
//  Created by student on 29/05/26.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), quote: "In the depths of winter, I finally learned...", genre: "Philosophy")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), quote: "Read to live, not live to read.", genre: "Classic")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        // Mengatur siklus pembaruan Widget setiap 2 jam sekali
        let refreshDate = Calendar.current.date(byAdding: .hour, value: 2, to: currentDate)!
        
        let entry = SimpleEntry(date: currentDate, quote: "The secret of getting ahead is getting started.", genre: "Fiction")
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let quote: String
    let genre: String
}

struct HiddenShelfWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("📚 Hidden Shelf Quote")
                    .font(.caption2)
                    .bold()
                    .foregroundColor(Theme.carob)
                Spacer()
            }
            
            Text("\"\(entry.quote)\"")
                .font(.system(.footnote, design: .serif))
                .italic()
                .foregroundColor(Theme.carob)
                .lineLimit(3)
            
            Spacer()
            
            Text(entry.genre)
                .font(.system(size: 9))
                .padding(.vertical, 3)
                .padding(.horizontal, 8)
                .background(Color(hex: "809671").opacity(0.2))
                .cornerRadius(8)
                .foregroundColor(Theme.carob)
        }
        .padding()
        .background(Theme.almond) // Warna Almond global
    }
}

@main
struct HiddenShelfWidget: Widget {
    let kind: String = "HiddenShelfWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HiddenShelfWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Hidden Shelf Daily Quote")
        .description("Menampilkan kutipan buku misteri dari pengguna sekitar secara acak.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
