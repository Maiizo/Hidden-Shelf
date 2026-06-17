//
//  Untitled.swift
//  Hidden Shelf
//
//  Created by student on 04/06/26.
//

import XCTest
@testable import Hidden_Shelf

@MainActor
final class MatchViewModelTests: XCTestCase {
    
    var viewModel: MatchViewModel!

    override func setUpWithError() throws {
        viewModel = MatchViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    // MARK: - 1. Test Inisialisasi
    func testInitialState() throws {
        // Assert state bawaan saat MatchViewModel dipanggil
        XCTAssertNotNil(viewModel.currentMatch, "Harusnya ada dummy match untuk titik temu UC Surabaya")
        XCTAssertEqual(viewModel.statusStep, 0, "Langkah status harusnya dimulai dari 0 (On the Way)")
        XCTAssertFalse(viewModel.showConfirmationPopup, "Pop-up konfirmasi harusnya belum muncul di awal")
    }
    
    // MARK: - 2. Test Transisi Step (Next Step)
    func testNextStepTransitions() throws {
        // Arrange & Act 1: Step 0 ke 1
        viewModel.nextStep()
        
        // Assert 1
        XCTAssertEqual(viewModel.statusStep, 1, "Status step seharusnya naik jadi 1")
        XCTAssertEqual(viewModel.currentMatch?.status, "Arrived", "Status buku harus berubah jadi 'Arrived'")
        
        // Act 2: Step 1 ke 2 (Memicu pop-up)
        viewModel.nextStep()
        
        // Assert 2
        XCTAssertEqual(viewModel.statusStep, 2, "Status step seharusnya naik jadi 2")
        XCTAssertTrue(viewModel.showConfirmationPopup, "Pop-up konfirmasi HARUS muncul ketika user menekan Finish Swapping")
    }
    
    // MARK: - 3. Test Konfirmasi Selesai (Complete Swap)
    func testCompleteSwap() throws {
        // Act
        viewModel.completeSwap()
        
        // Assert
        XCTAssertEqual(viewModel.currentMatch?.status, "Swap Complete", "Status final harus 'Swap Complete'")
    }
    
    // MARK: - 4. Test Pembatalan Pop-up (Reset Swap)
    func testResetSwap() throws {
        // Arrange: Simulasikan user membatalkan penyelesaian
        viewModel.statusStep = 2
        viewModel.showConfirmationPopup = true
        
        // Act
        viewModel.resetSwap()
        
        // Assert
        XCTAssertEqual(viewModel.statusStep, 1, "Step harus kembali ke 1 (Arrived) jika dibatalkan")
        XCTAssertFalse(viewModel.showConfirmationPopup, "Pop-up konfirmasi harus ditutup")
    }
}
