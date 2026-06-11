//
//  Match.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//
import Foundation
import CoreLocation
import FirebaseFirestore

struct Match: Identifiable, Codable {
    @DocumentID var id: String?
    var bookId: String
    var requesterId: String
    var ownerId: String
    
    // 💡 PERUBAHAN: Status dipisah menjadi dua
    var requesterStatus: Int
    var ownerStatus: Int
    
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
