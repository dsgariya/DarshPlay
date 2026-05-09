//
//  HintOverlayView.swift
//  TinyGlow
//
//  One-time hint overlay shown on the first learn session.
//  Auto-dismisses after 5 seconds or on "Got it!" tap.
//

import SwiftUI

struct HintOverlayView: View {

    let onDismiss: () -> Void

    @State private var tapScale    : CGFloat = 1.0
    @State private var swipeOffset : CGFloat = 0
    @State private var opacity     : Double  = 0

    var body: some View {
        ZStack {
            // Dimmed backdrop — tap anywhere to dismiss
            Color.black.opacity(0.52)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            VStack(spacing: 32) {

                Text("Here's how it works")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                // Hint 1 — Tap
                HintRow(
                    icon:      "hand.tap.fill",
                    text:      "Tap to hear the sound",
                    iconColor: Color(red: 1.00, green: 0.85, blue: 0.30)
                )
                .scaleEffect(tapScale)
                .animation(
                    .easeInOut(duration: 0.55).repeatForever(autoreverses: true),
                    value: tapScale
                )

                // Hint 2 — Swipe
                HintRow(
                    icon:      "hand.draw.fill",
                    text:      "Swipe to explore more",
                    iconColor: Color(red: 0.40, green: 0.85, blue: 1.00)
                )
                .offset(x: swipeOffset)
                .animation(
                    .easeInOut(duration: 0.65).repeatForever(autoreverses: true),
                    value: swipeOffset
                )

                // Got it button
                Button(action: dismiss) {
                    Text("Got it!")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 52)
                        .padding(.vertical, 14)
                        .background(Capsule().fill(Color(red: 0.25, green: 0.72, blue: 0.42)))
                }
                .padding(.top, 6)
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 36)
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .padding(.horizontal, 28)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.35)) { opacity = 1 }
            tapScale    = 1.13
            swipeOffset = 12
        }
    }

    // MARK: - Dismiss

    private func dismiss() {
        withAnimation(.easeOut(duration: 0.25)) { opacity = 0 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { onDismiss() }
    }
}

// MARK: - Hint Row

private struct HintRow: View {
    let icon      : String
    let text      : String
    let iconColor : Color

    var body: some View {
        HStack(spacing: 18) {
            Image(systemName: icon)
                .font(.system(size: 38, weight: .medium))
                .foregroundColor(iconColor)
                .frame(width: 52)

            Text(text)
                .font(.system(size: 21, weight: .semibold, design: .rounded))
                .foregroundColor(.white)

            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color(red: 1.00, green: 0.88, blue: 0.72).ignoresSafeArea()
        HintOverlayView(onDismiss: {})
    }
}
