//
//  Match.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import MapKit
import Foundation
import CoreLocation

struct Match: Identifiable, Codable {
    let id: String
    let bookId: String
    let requesterId: String
    let ownerId: String
    var status: String // "On the Way", "Arrived", "Swap Complete"
    
    // Simpan koordinat lokasi ketemuan
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
