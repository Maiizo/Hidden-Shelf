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
import SwiftUI

class MatchViewModel: ObservableObject {
    @Published var currentMatch: Match?
    @Published var statusStep: Int = 0 // 0: On the Way, 1: Arrived, 2: Swap Complete
    
    // 1. Added for the AS DOS confirmation pop-up
    @Published var showConfirmationPopup: Bool = false
    
    // 2. iOS 17 MapKit approach
    @Published var cameraPosition: MapCameraPosition = .automatic
    
    init() {
        // Mock data targeting Universitas Ciputra Surabaya
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
        updateCameraPosition(for: ucLocation)
    }
    
    func updateCameraPosition(for match: Match) {
        let region = MKCoordinateRegion(
            center: match.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        // Set the initial camera position based on the region
        self.cameraPosition = .region(region)
    }
    
    func nextStep() {
        if statusStep < 2 {
            statusStep += 1
            if statusStep == 1 {
                currentMatch?.status = "Arrived"
            } else if statusStep == 2 {
                // Trigger the confirmation pop-up before finalizing
                showConfirmationPopup = true
            }
        }
    }
    
    func completeSwap() {
        currentMatch?.status = "Swap Complete"
        // TODO: Add your Firebase logic here to update the database
    }
    
    func resetSwap() {
        // Revert to "Arrived" if they cancel the pop-up
        statusStep = 1
        showConfirmationPopup = false
    }
}
