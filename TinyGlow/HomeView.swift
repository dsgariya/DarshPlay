//
//  HomeView.swift
//  TinyGlow
//
//  Parent-facing landing screen.
//  Each card: tap → Learn mode   |   "🎯 Quiz" button → Quiz mode
//

import SwiftUI

// MARK: - Home View

struct HomeView: View {

    @ObservedObject var settings       : AppSettings
    @ObservedObject var audio          : AudioManager
    let onLearn : (ContentCategory) -> Void
    let onQuiz  : (ContentCategory) -> Void

    @Environment(\.verticalSizeClass) private var verticalSizeClass

    // 3 columns in landscape, 2 in portrait
    private var columns: [GridItem] {
        let count = (verticalSizeClass == .compact) ? 3 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 14), count: count)
    }

    private var isLandscape: Bool { verticalSizeClass == .compact }

    var body: some View {
        ScrollView(.vertical, showsIndicators: isLandscape) {
            VStack(spacing: 0) {

                // MARK: Header
                VStack(spacing: isLandscape ? 2 : 6) {
                    Text("Darsh Play")
                        .font(.system(size: isLandscape ? 28 : 40, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.25, green: 0.18, blue: 0.38))
                    Text("Choose what to learn today")
                        .font(.system(size: isLandscape ? 15 : 20, weight: .medium, design: .rounded))
                        .foregroundColor(Color(red: 0.48, green: 0.40, blue: 0.60))
                }
                .padding(.top,    isLandscape ? 14 : 52)
                .padding(.bottom, isLandscape ? 12 : 36)

                // MARK: Category Grid
                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(ContentCategory.allCases) { category in
                        CategoryCard(
                            category:  category,
                            isCompact: isLandscape,
                            onLearn:   { onLearn(category) },
                            onQuiz:    { onQuiz(category)  }
                        )
                    }
                }
                .padding(.horizontal, isLandscape ? 20 : 28)

                Spacer().frame(height: isLandscape ? 20 : 40)
            }
        }
        .background {
            LinearGradient(
                colors: [
                    Color(red: 1.00, green: 0.88, blue: 0.72),
                    Color(red: 0.92, green: 0.82, blue: 1.00),
                ],
                startPoint: .topLeading,
                endPoint:   .bottomTrailing
            )
            .ignoresSafeArea()
        }
    }
}

// MARK: - Category Card

/// Mirrors the system press state into a binding so the parent card can
/// animate as a whole — without using DragGesture, which blocks ScrollView.
private struct CardPressStyle: ButtonStyle {
    @Binding var isPressed: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { isPressed = configuration.isPressed }
    }
}

private struct CategoryCard: View {

    let category  : ContentCategory
    let isCompact : Bool               // true in landscape
    let onLearn   : () -> Void
    let onQuiz    : () -> Void

    @State private var isPressed = false

    private var itemCount  : Int    { items(for: category).count }
    private var iconSize   : CGFloat { isCompact ? 60 : 96  }
    private var titleSize  : CGFloat { isCompact ? 17 : 24  }
    private var badgeSize  : CGFloat { isCompact ? 12 : 15  }
    private var cardPadV   : CGFloat { isCompact ? 12 : 22  }
    private var quizPadV   : CGFloat { isCompact ?  8 : 12  }
    private var quizFontSz : CGFloat { isCompact ? 15 : 18  }

    var body: some View {
        VStack(spacing: 0) {

            // ── Main learn area ──────────────────────────────
            Button(action: onLearn) {
                VStack(spacing: isCompact ? 8 : 14) {
                    // Icon circle
                    ZStack {
                        Circle()
                            .fill(iconBackground)
                            .frame(width: iconSize, height: iconSize)
                        iconContent
                    }

                    Text(category.rawValue)
                        .font(.system(size: titleSize, weight: .bold, design: .rounded))
                        .foregroundColor(labelColor)

                    Text("\(itemCount) items")
                        .font(.system(size: badgeSize, weight: .medium, design: .rounded))
                        .foregroundColor(labelColor.opacity(0.6))
                        .padding(.horizontal, 12).padding(.vertical, 4)
                        .background(labelColor.opacity(0.10))
                        .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, cardPadV)
                .contentShape(Rectangle())              // full card area is tappable
            }
            .buttonStyle(CardPressStyle(isPressed: $isPressed))

            Divider().background(labelColor.opacity(0.12))

            // ── Quiz button ──────────────────────────────────
            Button(action: onQuiz) {
                HStack(spacing: 8) {
                    Text("🎯")
                        .font(.system(size: quizFontSz))
                    Text("Quiz")
                        .font(.system(size: quizFontSz, weight: .semibold, design: .rounded))
                        .foregroundColor(labelColor)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, quizPadV)
                .contentShape(Rectangle())              // full quiz bar is tappable
            }
            .buttonStyle(PlainButtonStyle())
            .background(labelColor.opacity(0.07))
        }
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .shadow(color: labelColor.opacity(0.13), radius: 14, x: 0, y: 5)
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.22, dampingFraction: 0.6), value: isPressed)
    }

    // MARK: Icon content per category

    @ViewBuilder
    private var iconContent: some View {
        let imageName: String = {
            switch category {
            case .animals: return "animal"
            case .colors:  return "color"
            case .shapes:  return "shaps"
            case .numbers: return "numbers"
            case .abc:     return "abc"
            }
        }()

        Image(imageName)
            .resizable()
            .scaledToFit()
            .padding(isCompact ? 10 : 14)
    }

    // MARK: Colors

    private var cardBackground: Color {
        switch category {
        case .animals: return Color(red: 1.00, green: 0.88, blue: 0.72)
        case .colors:  return Color(red: 0.78, green: 0.95, blue: 0.85)
        case .shapes:  return Color(red: 0.78, green: 0.90, blue: 1.00)
        case .numbers: return Color(red: 1.00, green: 0.90, blue: 0.78)
        case .abc:     return Color(red: 0.92, green: 0.82, blue: 1.00)
        }
    }

    private var iconBackground: Color {
        switch category {
        case .animals: return Color(red: 1.00, green: 0.72, blue: 0.48)
        case .colors:  return Color(red: 0.55, green: 0.88, blue: 0.70)
        case .shapes:  return Color(red: 0.55, green: 0.78, blue: 1.00)
        case .numbers: return Color(red: 1.00, green: 0.72, blue: 0.50)
        case .abc:     return Color(red: 0.78, green: 0.62, blue: 1.00)
        }
    }

    private var labelColor: Color {
        switch category {
        case .animals: return Color(red: 0.60, green: 0.30, blue: 0.05)
        case .colors:  return Color(red: 0.05, green: 0.42, blue: 0.28)
        case .shapes:  return Color(red: 0.05, green: 0.28, blue: 0.60)
        case .numbers: return Color(red: 0.60, green: 0.22, blue: 0.05)
        case .abc:     return Color(red: 0.38, green: 0.10, blue: 0.65)
        }
    }
}

#Preview {
    HomeView(
        settings: AppSettings(),
        audio:    AudioManager(),
        onLearn:  { _ in },
        onQuiz:   { _ in }
    )
}
