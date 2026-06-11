//
//  Models.swift
//  TinyGlow
//
//  Data models and content for all learning categories.
//

import SwiftUI
import Combine

// MARK: - App Settings

class AppSettings: ObservableObject {
    @Published var isSoundEnabled   : Bool            = true
    @Published var selectedCategory : ContentCategory = .animals
    @Published var isInCalmMode     : Bool            = false
}

// MARK: - Content Category

enum ContentCategory: String, CaseIterable, Identifiable {
    case animals = "Animals"
    case colors  = "Colors"
    case shapes  = "Shapes"
    case numbers = "Numbers"
    case abc     = "ABC"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .animals: return "🐾"
        case .colors:  return "🎨"
        case .shapes:  return "⬟"
        case .numbers: return "123"
        case .abc:     return "🔤"
        }
    }

    var background: Color {
        switch self {
        case .animals: return Color(red: 1.00, green: 0.88, blue: 0.72) // warm peach
        case .colors:  return Color(red: 0.78, green: 0.95, blue: 0.85) // soft mint
        case .shapes:  return Color(red: 0.78, green: 0.90, blue: 1.00) // sky blue
        case .numbers: return Color(red: 1.00, green: 0.90, blue: 0.78) // soft coral
        case .abc:     return Color(red: 0.92, green: 0.82, blue: 1.00) // lilac
        }
    }

    /// Accent used for quiz question bar
    var accentColor: Color {
        switch self {
        case .animals: return Color(red: 0.80, green: 0.42, blue: 0.08)
        case .colors:  return Color(red: 0.08, green: 0.52, blue: 0.34)
        case .shapes:  return Color(red: 0.08, green: 0.36, blue: 0.72)
        case .numbers: return Color(red: 0.75, green: 0.28, blue: 0.12)
        case .abc:     return Color(red: 0.46, green: 0.12, blue: 0.74)
        }
    }
}

// MARK: - Learning Item

struct LearningItem: Identifiable {
    let id        = UUID()
    let name      : String
    let soundText : String
    let category  : ContentCategory
    let display   : DisplayType

    enum DisplayType {
        case image(String)          // asset catalog name
        case emoji(String)          // fallback if no image asset
        case solidColor(Color)
        case shape(ShapeKind, Color)
        case letter(String, Color)
        case number(Int, Color)
    }

    enum ShapeKind {
        case circle, square, triangle, star
    }
}

// MARK: - Animals  (asset names must match exactly what's in Assets.xcassets)

let animalsContent: [LearningItem] = [
    // soundText = what TTS speaks on tap
    // animals with no distinct sound → speak the name instead
    .init(name: "Cow",       soundText: "Moo",       category: .animals, display: .image("cow")),
    .init(name: "Cat",       soundText: "Meow",      category: .animals, display: .image("cat")),
    .init(name: "Dog",       soundText: "Woof",      category: .animals, display: .image("dog")),
    .init(name: "Duck",      soundText: "Quack",     category: .animals, display: .image("duck")),
    .init(name: "Horse",     soundText: "Neigh",     category: .animals, display: .image("horse")),
    .init(name: "Sheep",     soundText: "Baa",       category: .animals, display: .image("sheep")),
    .init(name: "Frog",      soundText: "Ribbit",    category: .animals, display: .image("frog")),
    .init(name: "Bee",       soundText: "Buzz",      category: .animals, display: .image("bee")),
    .init(name: "Butterfly", soundText: "Butterfly", category: .animals, display: .image("buterfly")),
    .init(name: "Fish",      soundText: "Fish",      category: .animals, display: .image("fish")),
    .init(name: "Panda",     soundText: "Panda",     category: .animals, display: .image("panda")),
    .init(name: "Penguin",   soundText: "Penguin",   category: .animals, display: .image("penguin")),
    .init(name: "Bird",      soundText: "Tweet",     category: .animals, display: .image("bird")),
    .init(name: "Elephant",  soundText: "Elephant",  category: .animals, display: .image("elephant")),
    .init(name: "Giraffe",   soundText: "Giraffe",   category: .animals, display: .image("giraf")),
    .init(name: "Lion",      soundText: "Roar",      category: .animals, display: .image("lion")),
    .init(name: "Monkey",    soundText: "Monkey",    category: .animals, display: .image("monkey")),
    .init(name: "Zebra",     soundText: "Zebra",     category: .animals, display: .image("zebra")),
]

// MARK: - Colors

let colorsContent: [LearningItem] = [
    .init(name: "Red",    soundText: "Red",    category: .colors, display: .solidColor(.red)),
    .init(name: "Blue",   soundText: "Blue",   category: .colors, display: .solidColor(.blue)),
    .init(name: "Yellow", soundText: "Yellow", category: .colors, display: .solidColor(.yellow)),
    .init(name: "Green",  soundText: "Green",  category: .colors, display: .solidColor(.green)),
    .init(name: "Orange", soundText: "Orange", category: .colors, display: .solidColor(.orange)),
    .init(name: "Purple", soundText: "Purple", category: .colors, display: .solidColor(.purple)),
    .init(name: "Pink",   soundText: "Pink",   category: .colors, display: .solidColor(.pink)),
]

// MARK: - Shapes

private let shapeBlue   = Color(red: 0.40, green: 0.70, blue: 1.00)
private let shapeOrange = Color(red: 1.00, green: 0.60, blue: 0.35)
private let shapeGreen  = Color(red: 0.40, green: 0.82, blue: 0.50)
private let shapeYellow = Color(red: 1.00, green: 0.85, blue: 0.25)

let shapesContent: [LearningItem] = [
    .init(name: "Circle",   soundText: "Circle",   category: .shapes, display: .shape(.circle,   shapeBlue)),
    .init(name: "Square",   soundText: "Square",   category: .shapes, display: .shape(.square,   shapeOrange)),
    .init(name: "Triangle", soundText: "Triangle", category: .shapes, display: .shape(.triangle, shapeGreen)),
    .init(name: "Star",     soundText: "Star",     category: .shapes, display: .shape(.star,     shapeYellow)),
]

// MARK: - Numbers (1–10)

private let numberColors: [Color] = [
    Color(red: 0.95, green: 0.35, blue: 0.35), // 1 red
    Color(red: 0.25, green: 0.60, blue: 0.95), // 2 blue
    Color(red: 0.30, green: 0.78, blue: 0.45), // 3 green
    Color(red: 0.95, green: 0.65, blue: 0.15), // 4 yellow
    Color(red: 0.70, green: 0.35, blue: 0.90), // 5 purple
    Color(red: 0.95, green: 0.45, blue: 0.20), // 6 orange
    Color(red: 0.20, green: 0.80, blue: 0.85), // 7 teal
    Color(red: 0.90, green: 0.30, blue: 0.65), // 8 pink
    Color(red: 0.45, green: 0.75, blue: 0.25), // 9 lime
    Color(red: 0.30, green: 0.45, blue: 0.95), // 10 indigo
]

private let numberWords = [
    1: "one", 2: "two",   3: "three", 4: "four", 5: "five",
    6: "six", 7: "seven", 8: "eight", 9: "nine", 10: "ten",
]

let numbersContent: [LearningItem] = (1...10).map { n in
    LearningItem(
        name:      "\(n)",
        soundText: numberWords[n] ?? "\(n)",
        category:  .numbers,
        display:   .number(n, numberColors[n - 1])
    )
}

// MARK: - ABC

private let abcPalette: [Color] = [
    .red, .blue, .green, .orange, .purple, .pink,
    Color(red: 0.20, green: 0.70, blue: 0.90),
    Color(red: 1.00, green: 0.50, blue: 0.20),
    Color(red: 0.50, green: 0.85, blue: 0.50),
    Color(red: 0.80, green: 0.40, blue: 0.90),
]

let abcContent: [LearningItem] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    .enumerated()
    .map { index, char in
        let letter = String(char)
        return LearningItem(
            name:      letter,
            soundText: letter.lowercased(),
            category:  .abc,
            display:   .letter(letter, abcPalette[index % abcPalette.count])
        )
    }

// MARK: - Helper

func items(for category: ContentCategory) -> [LearningItem] {
    switch category {
    case .animals: return animalsContent
    case .colors:  return colorsContent
    case .shapes:  return shapesContent
    case .numbers: return numbersContent
    case .abc:     return abcContent
    }
}

// MARK: - Quiz

struct QuizQuestion {
    let correct : LearningItem
    let choices : [LearningItem]   // 4 items, shuffled, includes correct

    /// Generate a random question for the given category
    static func make(for category: ContentCategory) -> QuizQuestion {
        let pool = items(for: category)
        guard let correct = pool.randomElement() else {
            // All categories are guaranteed non-empty; this path is unreachable in production.
            preconditionFailure("Content pool for category '\(category.rawValue)' is empty.")
        }
        let wrongs = pool.filter { $0.id != correct.id }.shuffled().prefix(3)
        return QuizQuestion(
            correct: correct,
            choices: ([correct] + Array(wrongs)).shuffled()
        )
    }
}
