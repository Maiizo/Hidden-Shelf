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
                
                guard let document = snapshot, document.exists else {
                    print("Dokumen match tidak ditemukan!")
                    return
                }
                
                do {
                    let match = try document.data(as: Match.self)
                    self.currentMatch = match
                    self.region.center = match.coordinate
                    
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
            
            // 💡 TAMBAHAN BARU: Panggil fungsi untuk mengubah status buku di database
            updateBookStatusToSwapped()
        }

    private func updateBookStatusToSwapped() {
            guard let match = currentMatch else { return }
            
            // Update dokumen buku berdasarkan bookId yang ada di Match
            db.collection("books").document(match.bookId).updateData([
                "status": ShelfStatus.swapped.rawValue,
                "isAvailable": false // Ubah ke false agar tidak muncul lagi di layar Discovery orang lain
            ]) { error in
                if let error = error {
                    print("Gagal mengubah status buku: \(error.localizedDescription)")
                } else {
                    print("Buku berhasil dipindah ke kategori Swapped di database!")
                }
            }
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
