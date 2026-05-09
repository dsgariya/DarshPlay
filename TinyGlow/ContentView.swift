//
//  ContentView.swift
//  TinyGlow
//
//  Root navigator.
//  Screens: home → learn | quiz | calm
//

import SwiftUI
import Firebase

private enum Screen {
    case home
    case learning
    case quiz
}

struct ContentView: View {

    @StateObject private var settings = AppSettings()
    @StateObject private var audio    = AudioManager()

    @State private var screen          : Screen  = .home
    @State private var currentIndex    : Int     = 0
    @State private var scale           : CGFloat = 1.0
    @State private var itemOpacity     : Double  = 1.0
    @State private var showParentSheet : Bool    = false

    @AppStorage("hasSeenHint") private var hasSeenHint: Bool = false

    private var currentItems: [LearningItem] { items(for: settings.selectedCategory) }
    private var currentItem:  LearningItem   { currentItems[currentIndex % currentItems.count] }

    /// Max image dimension that always fits within the screen with 20 pt margin on each side.
    private var learnImageSize: CGFloat { min(460, UIScreen.main.bounds.width - 40) }

    // MARK: - Body

    var body: some View {
        ZStack {
            switch screen {

            case .home:
                HomeView(
                    settings: settings,
                    audio:    audio,
                    onLearn: { category in
                        settings.selectedCategory = category
                        settings.isInCalmMode     = false
                        currentIndex = 0
                        withAnimation(.easeInOut(duration: 0.35)) { screen = .learning }
                    },
                    onQuiz: { category in
                        settings.selectedCategory = category
                        withAnimation(.easeInOut(duration: 0.35)) { screen = .quiz }
                    }
                )
                .transition(.opacity)

            case .learning:
                if settings.isInCalmMode {
                    CalmModeView(settings: settings, audio: audio, onGoHome: goHome)
                        .transition(.opacity)
                } else {
                    learnView.transition(.opacity)
                }

            case .quiz:
                QuizView(settings: settings, audio: audio, onGoHome: goHome)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: screen)
        .animation(.easeInOut(duration: 0.35), value: settings.isInCalmMode)
        .sheet(isPresented: $showParentSheet) {
            ParentControlsView(settings: settings, audio: audio, onGoHome: goHome)
        }
        .onChange(of: settings.selectedCategory) {
            currentIndex = 0
        }
    }

    // MARK: - Learn View

    private var learnView: some View {
        ZStack {
            settings.selectedCategory.background.ignoresSafeArea()

            VStack(spacing: 18) {
                ItemDisplayView(item: currentItem, size: learnImageSize)
                nameBadge(for: currentItem)
            }
            .scaleEffect(scale)
            .opacity(itemOpacity)

            // Subtle parent buttons — top corners
            VStack {
                HStack {
                    Button {
                        settings.isInCalmMode = false
                        goHome()
                    } label: {
                        Image(systemName: "house.circle.fill")
                            .font(.system(size: 38))
                            .foregroundStyle(.black.opacity(0.18))
                    }
                    .padding(20)

                    Spacer()

                    Button { showParentSheet = true } label: {
                        Image(systemName: "gearshape.circle.fill")
                            .font(.system(size: 38))
                            .foregroundStyle(.black.opacity(0.18))
                    }
                    .padding(20)
                }
                .padding(.top, 20)
                .padding(.horizontal, 8)
                Spacer()
            }

            // First-time hint overlay
            if !hasSeenHint {
                HintOverlayView { hasSeenHint = true }
                    .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())                          // whole screen is tappable/swipeable
        .onTapGesture { if hasSeenHint { handleTap() } }
        .gesture(
            DragGesture(minimumDistance: 40)
                .onEnded { value in
                    guard hasSeenHint else { return }
                    if value.translation.width < -40 {
                        advanceItem(direction: 1)           // swipe left  → next
                    } else if value.translation.width > 40 {
                        advanceItem(direction: -1)          // swipe right → previous
                    }
                }
        )
    }

    // MARK: - Tap Logic

    private func handleTap() {
        // Tap only plays sound — navigation is via swipe
        let hasDistinctSound = currentItem.soundText.lowercased() != currentItem.name.lowercased()
        let speech = (settings.selectedCategory == .animals && hasDistinctSound)
            ? "\(currentItem.name), \(currentItem.soundText)"
            : currentItem.soundText
        audio.speak(speech, enabled: settings.isSoundEnabled)
        bounce()
    }

    private func bounce() {
        withAnimation(.spring(response: 0.22, dampingFraction: 0.42)) { scale = 1.20 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            withAnimation(.spring(response: 0.38, dampingFraction: 0.65)) { scale = 1.0 }
        }
    }

    private func advanceItem(direction: Int = 1) {
        withAnimation(.easeOut(duration: 0.28)) { itemOpacity = 0 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) {
            currentIndex = (currentIndex + direction + currentItems.count) % currentItems.count
            withAnimation(.easeIn(duration: 0.38)) { itemOpacity = 1 }
        }
    }

    // MARK: - Name Badge

    @ViewBuilder
    private func nameBadge(for item: LearningItem) -> some View {
        let showSound = item.soundText.lowercased() != item.name.lowercased()

        VStack(spacing: 4) {
            // Animal / item name
            Text(item.name)
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundColor(settings.selectedCategory.accentColor)

            // Sound label — only when different from name (e.g. Cow → Moo)
            if showSound {
                Text(item.soundText)
                    .font(.system(size: 28, weight: .medium, design: .rounded))
                    .foregroundColor(settings.selectedCategory.accentColor.opacity(0.65))
            }
        }
        .padding(.horizontal, 36)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.white.opacity(0.55))
        )
    }

    // MARK: - Navigation

    private func goHome() {
        settings.isInCalmMode = false
        withAnimation(.easeInOut(duration: 0.35)) { screen = .home }
    }
}

#Preview { ContentView() }
