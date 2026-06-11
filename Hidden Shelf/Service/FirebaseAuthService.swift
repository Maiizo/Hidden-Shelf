//
//  FirebaseAuthService.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import Foundation
import FirebaseAuth
import Combine

class AuthStateManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isLoggedIn = (user != nil)
            }
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
