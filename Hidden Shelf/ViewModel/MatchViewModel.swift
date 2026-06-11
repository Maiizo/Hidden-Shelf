//
//  MatchViewModel.swift
//  Hidden Shelf
//

import Foundation
import Combine
import MapKit
import FirebaseFirestore
import FirebaseAuth

@MainActor
class MatchViewModel: ObservableObject {
    @Published var currentMatch: Match?
    @Published var myStatusStep: Int = 0
    @Published var partnerStatusStep: Int = 0
    @Published var showConfirmationPopup: Bool = false
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -7.2856, longitude: 112.6315),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?

    // Always reads the real logged-in user's UID live
    private var currentUserId: String {
        Auth.auth().currentUser?.uid ?? ""
    }

    func listenToMatch(matchId: String) {
        // Remove any existing listener first
        listenerRegistration?.remove()

        let docRef = db.collection("matches").document(matchId)

        listenerRegistration = docRef.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("❌ Error listening to match: \(error.localizedDescription)")
                return
            }

            guard let document = snapshot, document.exists,
                  let data = document.data() else {
                print("❌ Match document not found or empty")
                return
            }

            // Read fields manually — avoids Codable @DocumentID silent failures
            let bookId        = data["bookId"] as? String ?? ""
            let requesterId   = data["requesterId"] as? String ?? ""
            let ownerId       = data["ownerId"] as? String ?? ""
            let requesterStatus = data["requesterStatus"] as? Int ?? 0
            let ownerStatus     = data["ownerStatus"] as? Int ?? 0
            let latitude      = data["latitude"] as? Double ?? -7.2856
            let longitude     = data["longitude"] as? Double ?? 112.6315

            print("📡 Match update received:")
            print("   requesterId: \(requesterId)")
            print("   ownerId: \(ownerId)")
            print("   requesterStatus: \(requesterStatus)")
            print("   ownerStatus: \(ownerStatus)")
            print("   currentUserId: \(self.currentUserId)")

            // Build the Match object
            let match = Match(
                id: document.documentID,
                bookId: bookId,
                requesterId: requesterId,
                ownerId: ownerId,
                requesterStatus: requesterStatus,
                ownerStatus: ownerStatus,
                latitude: latitude,
                longitude: longitude
            )

            self.currentMatch = match
            self.region.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

            // Assign my vs partner status based on who I am
            if self.currentUserId == ownerId {
                self.myStatusStep      = ownerStatus
                self.partnerStatusStep = requesterStatus
                print("   👤 I am the OWNER")
            } else {
                self.myStatusStep      = requesterStatus
                self.partnerStatusStep = ownerStatus
                print("   👤 I am the REQUESTER")
            }

            print("   ✅ myStatus: \(self.myStatusStep), partnerStatus: \(self.partnerStatusStep)")
        }
    }

    func nextStep() {
        guard myStatusStep < 2 else { return }
        myStatusStep += 1
        if myStatusStep == 2 {
            showConfirmationPopup = true
        } else {
            updateMyStatusToFirebase()
        }
    }

    func completeSwap() {
        myStatusStep = 2
        updateMyStatusToFirebase()
        updateBookStatusToSwapped()
    }

    func resetSwap() {
        myStatusStep = 1
        showConfirmationPopup = false
        updateMyStatusToFirebase()
    }

    private func updateMyStatusToFirebase() {
        guard let match = currentMatch, let matchId = match.id else {
            print("❌ Cannot update — match or matchId is nil")
            return
        }

        // Decide which field belongs to me
        let fieldToUpdate: String
        if currentUserId == match.ownerId {
            fieldToUpdate = "ownerStatus"
        } else {
            fieldToUpdate = "requesterStatus"
        }

        print("📤 Updating \(fieldToUpdate) → \(myStatusStep) for match \(matchId)")

        db.collection("matches").document(matchId).updateData([
            fieldToUpdate: myStatusStep
        ]) { error in
            if let error = error {
                print("❌ Failed to update status: \(error.localizedDescription)")
            } else {
                print("✅ Status updated successfully")
            }
        }
    }

    private func updateBookStatusToSwapped() {
        guard let match = currentMatch else { return }

        db.collection("books").document(match.bookId).updateData([
            "status": ShelfStatus.swapped.rawValue,
            "isAvailable": false
        ]) { error in
            if let error = error {
                print("❌ Failed to update book status: \(error.localizedDescription)")
            } else {
                print("✅ Book moved to Swapped")
            }
        }
    }

    deinit {
        listenerRegistration?.remove()
    }
}
