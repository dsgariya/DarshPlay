//
//  TwoFingerLongPress.swift
//  TinyGlow
//
//  UIViewRepresentable that detects a 2-finger long press (2 seconds).
//  Used for the hidden parent controls trigger.
//

import SwiftUI
import UIKit

struct TwoFingerLongPressOverlay: UIViewRepresentable {

    let minimumDuration: TimeInterval
    let onTriggered: () -> Void

    init(minimumDuration: TimeInterval = 2.0, onTriggered: @escaping () -> Void) {
        self.minimumDuration = minimumDuration
        self.onTriggered     = onTriggered
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onTriggered: onTriggered)
    }

    func makeUIView(context: Context) -> UIView {
        let view = PassthroughView()
        view.backgroundColor = .clear

        let recognizer = UILongPressGestureRecognizer(
            target:  context.coordinator,
            action:  #selector(Coordinator.handleGesture(_:))
        )
        recognizer.numberOfTouchesRequired = 2
        recognizer.minimumPressDuration    = minimumDuration
        view.addGestureRecognizer(recognizer)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    // MARK: - Coordinator

    class Coordinator: NSObject {
        let onTriggered: () -> Void

        init(onTriggered: @escaping () -> Void) {
            self.onTriggered = onTriggered
        }

        @objc func handleGesture(_ gesture: UILongPressGestureRecognizer) {
            guard gesture.state == .began else { return }
            // Provide haptic feedback so parent knows it registered
            let feedback = UIImpactFeedbackGenerator(style: .medium)
            feedback.impactOccurred()
            onTriggered()
        }
    }
}

// MARK: - Pass-through View
// Allows tap gestures on the SwiftUI layer beneath to still fire.

private class PassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hit = super.hitTest(point, with: event)
        return hit == self ? nil : hit
    }
}

// MARK: - ViewModifier convenience

extension View {
    func onTwoFingerLongPress(
        minimumDuration: TimeInterval = 2.0,
        perform action: @escaping () -> Void
    ) -> some View {
        overlay(
            TwoFingerLongPressOverlay(minimumDuration: minimumDuration, onTriggered: action)
        )
    }
}
