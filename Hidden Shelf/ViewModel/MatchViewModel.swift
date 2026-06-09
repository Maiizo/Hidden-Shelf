//
//  MatchViewModel.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//
// MatchViewModel.swift
import Foundation
import Combine
import MapKit
import FirebaseFirestore

@MainActor
class MatchViewModel: ObservableObject {
    @Published var currentMatch: Match?
    
    // 💡 PERUBAHAN: Variabel status dipisah untuk UI
    @Published var myStatusStep: Int = 0
    @Published var partnerStatusStep: Int = 0
    @Published var showConfirmationPopup: Bool = false
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -7.2856, longitude: 112.6315),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    let currentUserId = "partnerUser" // Nanti ini diganti dengan ID Firebase Auth asli

        func listenToMatch(matchId: String) {
            let docRef = db.collection("matches").document(matchId)
            
            listenerRegistration = docRef.addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error mendengarkan match: \(error.localizedDescription)")
                    return
                }
                
                guard let document = snapshot else { return }
                
                // 💡 AUTO-CREATE: Jika data belum ada di Firebase, buat otomatis!
                if !document.exists {
                    print("Dokumen belum ada, membuat data dummy ke Firebase...")
                    docRef.setData([
                        "bookId": "buku_misteri_123",
                        "requesterId": "partnerUser", // ID Partner
                        "ownerId": self.currentUserId, // ID Kamu ("currentUser")
                        "requesterStatus": 0,
                        "ownerStatus": 0,
                        "latitude": -7.2856, // Koordinat UC Surabaya
                        "longitude": 112.6315
                    ])
                    return // Berhenti di sini, fungsi ini akan otomatis terpanggil lagi setelah data terbuat
                }
                
                // Jika data sudah ada, langsung proses (Real-Time Sync)
                do {
                    let match = try document.data(as: Match.self)
                    self.currentMatch = match
                    self.region.center = match.coordinate
                    
                    // Logika penentu: Apakah kamu Owner atau Requester?
                    if match.ownerId == self.currentUserId {
                        self.myStatusStep = match.ownerStatus
                        self.partnerStatusStep = match.requesterStatus
                    } else {
                        self.myStatusStep = match.requesterStatus
                        self.partnerStatusStep = match.ownerStatus
                    }
                } catch {
                    print("Error decoding match data: \(error.localizedDescription)")
                }
            }
        }
    
    func nextStep() {
        if myStatusStep < 2 {
            myStatusStep += 1
            if myStatusStep == 2 {
                showConfirmationPopup = true
            } else {
                updateMyStatusToFirebase()
            }
        }
    }
    
    func completeSwap() {
        myStatusStep = 2
        updateMyStatusToFirebase()
    }
    
    func resetSwap() {
        myStatusStep = 1
        showConfirmationPopup = false
        updateMyStatusToFirebase()
    }
    
    // 💡 FUNGSI BARU: Mengirim status KAMU saja ke Firebase
    private func updateMyStatusToFirebase() {
        guard let match = currentMatch, let matchId = match.id else { return }
        
        let fieldToUpdate = (match.ownerId == currentUserId) ? "ownerStatus" : "requesterStatus"
        
        db.collection("matches").document(matchId).updateData([
            fieldToUpdate: myStatusStep
        ]) { error in
            if let error = error {
                print("Gagal update status: \(error.localizedDescription)")
            }
        }
    }
    
    deinit {
        // Matikan listener kalau pindah layar agar tidak boros internet
        listenerRegistration?.remove()
    }
}
