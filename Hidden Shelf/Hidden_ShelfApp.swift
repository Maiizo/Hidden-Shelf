//
//  Hidden_ShelfApp.swift
//  Hidden Shelf
//
//  Created by student on 29/05/26.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct Hidden_ShelfApp: App {
    // Register the AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authManager = AuthStateManager()
    
    var body: some Scene {
        WindowGroup {
            if authManager.isLoggedIn {
                          ContentView()
                              .environmentObject(authManager)
                              .onOpenURL { url in
                                  // Cek apakah URL-nya dari widget kita
                                  if url.scheme == "hiddenshelf" && url.host == "book" {
                                      let bookId = url.lastPathComponent
                                      print("User membuka aplikasi dari widget untuk Buku ID: \(bookId)")
                                      
                                      // TODO: Tambahkan logika jika ingin otomatis pindah tab atau buka detail buku
                                  }
                              }
                      } else {
                          LoginView()
                              .environmentObject(authManager)
                      }
      
         
        }
    }
}
