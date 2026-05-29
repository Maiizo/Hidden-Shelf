//
//  MatchView.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import SwiftUI
import MapKit

// MARK: - Mock Data Models
struct SwapMatch: Identifiable {
    let id = UUID()
    let partnerName: String
    let bookToReceive: String
    let bookToGive: String
    let meetupPlaceName: String
    let meetupAddress: String
    let coordinate: CLLocationCoordinate2D
    let scheduledTime: String
}

struct MatchView: View {
    @State private var match = SwapMatch(
        partnerName: "Rian",
        bookToReceive: "The Hobbit",
        bookToGive: "Sapiens",
        meetupPlaceName: "Caturra Espresso (Safe Zone)",
        meetupAddress: "Jl. Anjasmoro No.56, Surabaya",
        coordinate: CLLocationCoordinate2D(latitude: -7.2622, longitude: 112.7392),
        scheduledTime: "Tomorrow, 4:00 PM"
    )
    
    // Map camera position configuration
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -7.2622, longitude: 112.7392),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
    )
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea() // Matches your clean app backgrounds
            
            VStack(spacing: 0) {
                // 1. TOP HEADER BANNER
                VStack(spacing: 6) {
                    Text("Match Found! 🎉")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.appCarob)
                    
                    Text("Time to trade your book with \(match.partnerName)")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.appCarob.opacity(0.7))
                }
                .padding(.vertical, 24)
                
                // 2. THE SWAP CARD (Visualizing the trade)
                HStack(spacing: 16) {
                    VStack(alignment: .center, spacing: 4) {
                        Text("YOU GIVE")
                            .font(.system(.caption2, design: .rounded)).bold()
                            .foregroundColor(.appCarob.opacity(0.5))
                        Text(match.bookToGive)
                            .font(.system(.body, design: .rounded)).bold()
                            .foregroundColor(.appCarob)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Image(systemName: "arrow.left.and.right.circle.fill")
                        .font(.title2)
                        .foregroundColor(.appPistache)
                    
                    VStack(alignment: .center, spacing: 4) {
                        Text("YOU RECEIVE")
                            .font(.system(.caption2, design: .rounded)).bold()
                            .foregroundColor(.appCarob.opacity(0.5))
                        Text(match.bookToReceive)
                            .font(.system(.body, design: .rounded)).bold()
                            .foregroundColor(.appCarob)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.appPistache.opacity(0.15))
                .cornerRadius(16)
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                // 3. MAPKIT VIEW (The Meetup Point)
                VStack(alignment: .leading, spacing: 0) {
                    Map(position: $position) {
                        Annotation(match.meetupPlaceName, coordinate: match.coordinate) {
                            ZStack {
                                Circle()
                                    .fill(Color.appCarob)
                                    .frame(width: 40, height: 40)
                                Image(systemName: "books.vertical.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                            }
                        }
                    }
                    .frame(height: 200)
                    .cornerRadius(16, corners: [.topLeft, .topRight])
                    
                    // Location Details Text block below Map
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .top) {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.appCarob)
                                .font(.headline)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(match.meetupPlaceName)
                                    .font(.system(.callout, design: .rounded)).bold()
                                    .foregroundColor(.appCarob)
                                Text(match.meetupAddress)
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Divider()
                        
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.appCarob)
                                .font(.subheadline)
                            Text(match.scheduledTime)
                                .font(.system(.footnote, design: .rounded)).bold()
                                .foregroundColor(.appCarob)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
                }
                .padding(.horizontal)
                
                Spacer()
                
                // 4. BOTTOM ACTION BUTTONS
                VStack(spacing: 12) {
                    Button(action: {
                        // Action to slide into the chat module handled by your friend
                    }) {
                        HStack {
                            Image(systemName: "message.fill")
                            Text("Chat with \(match.partnerName)")
                        }
                        .font(.system(.body, design: .rounded)).bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.appCarob)
                        .cornerRadius(14)
                    }
                    
                    Button(action: {
                        // Cancel or reschedule logic
                    }) {
                        Text("Cancel or Reschedule")
                            .font(.system(.footnote, design: .rounded))
                            .foregroundColor(.red.opacity(0.8))
                            .padding(.vertical, 4)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
        }
    }
}

// Helper extension to selectively corner-radius sections of the Map container
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
#Preview {
    MatchView()
}
