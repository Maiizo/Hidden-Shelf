//
//  MatchViewModel.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//
// MatchViewModel.swift

import Foundation
import MapKit
import Combine

class MatchViewModel: ObservableObject {
    @Published var currentMatch: Match?
    @Published var statusStep: Int = 0
    @Published var showConfirmationPopup: Bool = false
    
    // WAJIB menggunakan region agar tidak error di MatchView
    @Published var region: MKCoordinateRegion
    
    init() {
        let ucLocation = Match(
            id: "match_123",
            bookId: "book_abc",
            requesterId: "user_1",
            ownerId: "user_2",
            status: "On the Way",
            latitude: -7.2858,
            longitude: 112.6316
        )
        self.currentMatch = ucLocation
        
        // Inisialisasi Region
        self.region = MKCoordinateRegion(
            center: ucLocation.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
    
    func nextStep() {
        if statusStep < 2 {
            statusStep += 1
            if statusStep == 1 {
                currentMatch?.status = "Arrived"
            } else if statusStep == 2 {
                showConfirmationPopup = true
            }
        }
    }
    
    func completeSwap() {
        currentMatch?.status = "Swap Complete"
    }
    
    func resetSwap() {
        statusStep = 1
        showConfirmationPopup = false
    }
}
