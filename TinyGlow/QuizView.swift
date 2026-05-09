//
//  QuizView.swift
//  TinyGlow
//
//  Quiz mode: question spoken aloud, 4 large choice cards, score tracker.
//  Correct → celebration burst + next question.
//  Wrong   → gentle red shake + replay question. No penalty.
//

import SwiftUI

// MARK: - Quiz View

struct QuizView: View {

    @ObservedObject var settings : AppSettings
    @ObservedObject var audio    : AudioManager
    let onGoHome                 : () -> Void

    @State private var question        = QuizQuestion.make(for: .animals)
    @State private var tappedID        : UUID?  = nil
    @State private var isAnsweredRight : Bool   = false
    @State private var isLocked        : Bool   = false
    @State private var score           : Int    = 0
    @State private var showCelebration : Bool   = false
    @State private var showParentSheet : Bool   = false

    private let columns = [
        GridItem(.flexible(), spacing: 18),
        GridItem(.flexible(), spacing: 18),
    ]

    // MARK: - Body

    var body: some View {
        ZStack {
            settings.selectedCategory.background.ignoresSafeArea()

            VStack(spacing: 0) {
                topBar.padding(.horizontal, 24).padding(.top, 36).padding(.bottom, 14)
                questionCard.padding(.horizontal, 24).padding(.bottom, 20)
                choiceGrid.padding(.horizontal, 24)
                Spacer(minLength: 0)
            }

            if showCelebration {
                CelebrationOverlay()
                    .allowsHitTesting(false)
                    .transition(.scale(scale: 0.6).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.35), value: showCelebration)
        .onAppear { loadQuestion() }
        .sheet(isPresented: $showParentSheet) {
            ParentControlsView(settings: settings, audio: audio, onGoHome: onGoHome)
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Button(action: onGoHome) {
                Image(systemName: "house.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.black.opacity(0.22))
            }

            Spacer()

            // Score pill
            HStack(spacing: 8) {
                Image(systemName: "star.fill").foregroundColor(.yellow)
                Text("\(score)")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(settings.selectedCategory.accentColor)
            }
            .padding(.horizontal, 18).padding(.vertical, 8)
            .background(.white.opacity(0.55))
            .clipShape(Capsule())

            Spacer()

            Button { showParentSheet = true } label: {
                Image(systemName: "gearshape.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.black.opacity(0.22))
            }
        }
    }

    // MARK: - Question Card

    private var questionCard: some View {
        Button(action: speakQuestion) {
            HStack(spacing: 14) {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white.opacity(0.85))
                Text(questionPrompt)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(.horizontal, 22).padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(settings.selectedCategory.accentColor.opacity(0.80))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var questionPrompt: String {
        switch settings.selectedCategory {
        case .animals: return "Find the \(question.correct.name)!"
        case .colors:  return "Tap \(question.correct.name)!"
        case .shapes:  return "Find the \(question.correct.name)!"
        case .numbers: return "Find number \(question.correct.name)!"
        case .abc:     return "Find the letter \(question.correct.name)!"
        }
    }

    // MARK: - Choice Grid

    private var choiceGrid: some View {
        LazyVGrid(columns: columns, spacing: 18) {
            ForEach(question.choices) { choice in
                ChoiceCard(
                    item:    choice,
                    state:   cardState(for: choice),
                    onTap:   { handleTap(choice) }
                )
            }
        }
    }

    private func cardState(for item: LearningItem) -> ChoiceCard.CardState {
        guard let id = tappedID else { return .idle }
        if item.id == question.correct.id { return isAnsweredRight ? .correct : .idle }
        return item.id == id ? .wrong : .idle
    }

    // MARK: - Logic

    private func handleTap(_ choice: LearningItem) {
        guard !isLocked, tappedID == nil else { return }
        isLocked = true
        tappedID = choice.id

        if choice.id == question.correct.id {
            isAnsweredRight = true
            score += 1
            audio.speak("Yay! Great job!", enabled: settings.isSoundEnabled)
            withAnimation { showCelebration = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation { showCelebration = false }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { loadQuestion() }
            }
        } else {
            audio.speak("Try again!", enabled: settings.isSoundEnabled)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                tappedID = nil
                isLocked = false
                speakQuestion()
            }
        }
    }

    private func loadQuestion() {
        question        = QuizQuestion.make(for: settings.selectedCategory)
        tappedID        = nil
        isAnsweredRight = false
        isLocked        = false
        speakQuestion()
    }

    private func speakQuestion() {
        audio.speak(questionPrompt, enabled: settings.isSoundEnabled)
    }
}

// MARK: - Choice Card

struct ChoiceCard: View {

    enum CardState { case idle, correct, wrong }

    let item  : LearningItem
    let state : CardState
    let onTap : () -> Void

    @State private var shakeOffset: CGFloat = 0

    var body: some View {
        Button(action: onTap) {
            ItemDisplayView(item: item, size: 155)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(borderColor, lineWidth: state == .idle ? 0 : 5)
                )
                .scaleEffect(state == .correct ? 1.05 : state == .wrong ? 0.94 : 1.0)
                .offset(x: shakeOffset)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.28), value: state)
        .onChange(of: state) {
            if state == .wrong { shake() }
        }
    }

    private var cardBackground: Color {
        switch state {
        case .idle:    return .white.opacity(0.65)
        case .correct: return Color(red: 0.75, green: 1.00, blue: 0.82)
        case .wrong:   return Color(red: 1.00, green: 0.80, blue: 0.78)
        }
    }

    private var borderColor: Color {
        switch state {
        case .idle:    return .clear
        case .correct: return Color(red: 0.18, green: 0.76, blue: 0.38)
        case .wrong:   return Color(red: 0.88, green: 0.22, blue: 0.18)
        }
    }

    private func shake() {
        let offsets: [CGFloat] = [10, -10, 8, -8, 5, -5, 0]
        var delay = 0.0
        for offset in offsets {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: 0.07)) { shakeOffset = offset }
            }
            delay += 0.07
        }
    }
}

// MARK: - Celebration Overlay

struct CelebrationOverlay: View {

    @State private var animate = false

    private let confettiColors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink
    ]

    var body: some View {
        ZStack {
            // Dim background
            Color.black.opacity(0.12).ignoresSafeArea()

            // Burst of stars
            ForEach(0..<12, id: \.self) { i in
                let angle  = Double(i) * 30.0
                let dist   : CGFloat = animate ? 220 : 0
                let opacity: Double  = animate ? 0   : 1

                Text(i.isMultiple(of: 3) ? "⭐" : "✨")
                    .font(.system(size: animate ? 28 : 48))
                    .offset(
                        x: dist * CGFloat(cos(angle * .pi / 180)),
                        y: dist * CGFloat(sin(angle * .pi / 180))
                    )
                    .opacity(opacity)
            }

            // Central emoji
            Text("🎉")
                .font(.system(size: animate ? 140 : 80))
                .scaleEffect(animate ? 1.0 : 0.4)
                .opacity(animate ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.55)) {
                animate = true
            }
        }
    }
}

#Preview {
    QuizView(
        settings: AppSettings(),
        audio:    AudioManager(),
        onGoHome: {}
    )
}
