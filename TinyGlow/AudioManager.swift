//
//  AudioManager.swift
//  TinyGlow
//
//  Wraps AVSpeechSynthesizer for gentle, baby-friendly voice output.
//  No audio files needed — everything is spoken aloud.
//

import AVFoundation
import Combine

class AudioManager: NSObject, ObservableObject {

    private let synthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        configureAudioSession()
    }

    // MARK: - Public

    /// Speak a word or sound with calm, baby-friendly settings.
    func speak(_ text: String, enabled: Bool) {
        guard enabled, !text.isEmpty else { return }
        synthesizer.stopSpeaking(at: .immediate)

        let utterance = AVSpeechUtterance(string: text)
        utterance.rate            = 0.38   // slow and clear
        utterance.pitchMultiplier = 1.15   // slightly higher, more engaging for babies
        utterance.volume          = 0.90
        utterance.preUtteranceDelay = 0.05

        // Always use English regardless of device locale
        utterance.voice = englishVoice

        synthesizer.speak(utterance)
    }

    /// Soft chime substitute for calm mode — whispered "mmm"
    func chime(enabled: Bool) {
        guard enabled else { return }
        synthesizer.stopSpeaking(at: .immediate)

        let utterance = AVSpeechUtterance(string: "mmm")
        utterance.rate            = 0.25
        utterance.pitchMultiplier = 1.60
        utterance.volume          = 0.60
        utterance.voice = englishVoice

        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }

    // MARK: - Voice selection

    /// Always resolves to an English voice regardless of device locale.
    private var englishVoice: AVSpeechSynthesisVoice? {
        // Prefer a named natural voice if available (downloaded on device)
        let preferred = ["Samantha", "Karen", "Moira"]
        for name in preferred {
            if let voice = AVSpeechSynthesisVoice.speechVoices()
                .first(where: { $0.name == name }) {
                return voice
            }
        }
        // Fallback: any en-US voice
        return AVSpeechSynthesisVoice(language: "en-US")
    }

    // MARK: - Private

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: [.mixWithOthers]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // Non-fatal — app still works without explicit session config
        }
    }
}
