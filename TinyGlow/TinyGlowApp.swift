//
//  TinyGlowApp.swift
//  TinyGlow
//
//  App entry point.
//  Status bar and home indicator are hidden for a distraction-free baby experience.
//

import SwiftUI
import Firebase

@main
struct TinyGlowApp: App {

    init() {
        // Initialise Firebase (Analytics + Crashlytics)
        FirebaseApp.configure()

        // Set window background to sky blue before any SwiftUI view renders.
        // This eliminates the 1–2 frame white flash on cold app start.
        UIWindow.appearance().backgroundColor = UIColor(
            red: 0.44, green: 0.78, blue: 0.95, alpha: 1
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .statusBarHidden(true)
                .persistentSystemOverlays(.hidden)
        }
    }
}
