//
//  CalmModeView.swift
//  TinyGlow
//
//  A dark, soothing screen. Tap anywhere → soft star sparkles at the tap point.
//  Designed to calm a baby, not stimulate.
//

import SwiftUI

// MARK: - Sparkle particle model

private struct Sparkle: Identifiable {
    let id       = UUID()
    let position : CGPoint
    var opacity  : Double = 1.0
    var scale    : CGFloat = 0.3
}

// MARK: - View

struct CalmModeView: View {

    @ObservedObject var settings : AppSettings
    @ObservedObject var audio    : AudioManager
    var onGoHome                 : (() -> Void)? = nil

    @State private var sparkles: [Sparkle] = []

    // Deep night-sky background gradient
    private let background = LinearGradient(
        colors: [
            Color(red: 0.05, green: 0.05, blue: 0.18),
            Color(red: 0.08, green: 0.08, blue: 0.28),
        ],
        startPoint: .top,
        endPoint:   .bottom
    )

    var body: some View {
        ZStack {
            background.ignoresSafeArea()
                .onAppear { TinyGlowAnalytics.logCalmModeEntered() }

            // Sparkle layer
            ForEach(sparkles) { sparkle in
                Image(systemName: "sparkle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.white)
                    .opacity(sparkle.opacity)
                    .scaleEffect(sparkle.scale)
                    .position(sparkle.position)
            }

            // Invisible tap receiver — full screen
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture(coordinateSpace: .global) { location in
                    addSparkle(at: location)
                }

            // Subtle parent buttons — top corners
            VStack {
                HStack {
                    Button {
                        settings.isInCalmMode = false
                        onGoHome?()
                    } label: {
                        Image(systemName: "house.circle.fill")
                            .font(.system(size: 38))
                            .foregroundStyle(.white.opacity(0.25))
                    }
                    .padding(20)

                    Spacer()

                    Button {
                        settings.isInCalmMode = false
                    } label: {
                        Image(systemName: "sun.max.circle.fill")
                            .font(.system(size: 38))
                            .foregroundStyle(.white.opacity(0.25))
                    }
                    .padding(20)
                }
                .padding(.top, 20)
                .padding(.horizontal, 8)
                Spacer()
            }
        }
    }

    // MARK: - Sparkle Logic

    private func addSparkle(at position: CGPoint) {
        audio.chime(enabled: settings.isSoundEnabled)
        TinyGlowAnalytics.logCalmModeTapped()

        let sparkle = Sparkle(position: position)
        sparkles.append(sparkle)

        // Animate in
        withAnimation(.easeOut(duration: 0.3)) {
            if let idx = sparkles.firstIndex(where: { $0.id == sparkle.id }) {
                sparkles[idx].scale = 1.0
            }
        }

        // Fade out after 1.5 s
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeIn(duration: 1.2)) {
                if let idx = sparkles.firstIndex(where: { $0.id == sparkle.id }) {
                    sparkles[idx].opacity = 0.0
                    sparkles[idx].scale   = 1.4
                }
            }
        }

        // Remove from array to avoid memory build-up
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            sparkles.removeAll { $0.id == sparkle.id }
        }
    }
}

#Preview {
    CalmModeView(
        settings: AppSettings(),
        audio:    AudioManager()
    )
}
