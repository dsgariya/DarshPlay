//
//  SplashView.swift
//  TinyGlow
//
//  SwiftUI branded splash — seamlessly continues from the sky-blue OS launch screen.
//  Shows Darsh Play logo text + tagline + character image, then fades out.
//

import SwiftUI

struct SplashView: View {

    var onFinished: () -> Void

    @State private var logoScale:    CGFloat = 0.7
    @State private var logoOpacity:  Double  = 0.0
    @State private var taglineOffset: CGFloat = 20
    @State private var screenOpacity: Double  = 1.0

    // Sky blue — must match LaunchBackground color in assets
    private let bgTop    = Color(red: 0.44, green: 0.78, blue: 0.95)
    private let bgBottom = Color(red: 0.25, green: 0.60, blue: 0.85)

    var body: some View {
        ZStack {
            // Background — matches OS launch screen exactly
            LinearGradient(colors: [bgTop, bgBottom],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Character image ─────────────────────────────
                Image("spash_screen")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 480)
                    .padding(.horizontal, 20)

                // ── "Darsh Play" title ──────────────────────────
                Text("Darsh Play")
                    .font(.system(size: 52, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 0.12, green: 0.60, blue: 0.18),
                                Color(red: 0.90, green: 0.40, blue: 0.05),
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: .white.opacity(0.6), radius: 2, x: 0, y: 1)
                    .padding(.top, 8)

                // ── Tagline ─────────────────────────────────────
                Text("Learn  •  Play  •  Grow")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.90))
                    .padding(.top, 10)
                    .offset(y: taglineOffset)
            }
            .scaleEffect(logoScale)
            .opacity(logoOpacity)
        }
        .opacity(screenOpacity)
        .onAppear { animateIn() }
    }

    // MARK: - Sequence

    private func animateIn() {
        withAnimation(.spring(response: 0.55, dampingFraction: 0.72)) {
            logoScale   = 1.0
            logoOpacity = 1.0
        }
        withAnimation(.easeOut(duration: 0.5).delay(0.15)) {
            taglineOffset = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            animateOut()
        }
    }

    private func animateOut() {
        withAnimation(.easeIn(duration: 0.4)) {
            screenOpacity = 0.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            onFinished()
        }
    }
}

#Preview {
    SplashView(onFinished: {})
}
