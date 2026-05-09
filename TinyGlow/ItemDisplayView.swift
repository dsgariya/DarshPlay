//
//  ItemDisplayView.swift
//  TinyGlow
//
//  Renders a single LearningItem.
//  `size` controls the canvas — pass a smaller value for quiz choice cards.
//

import SwiftUI
import UIKit

struct ItemDisplayView: View {

    let item : LearningItem
    var size : CGFloat = 460        // default: play mode; quiz uses ~160

    // Emoji shown if the named asset fails to load
    private static let emojiFallback: [String: String] = [
        "cow"      : "🐄",
        "cat"      : "🐱",
        "dog"      : "🐶",
        "duck"     : "🦆",
        "horse"    : "🐴",
        "sheep"    : "🐑",
        "frog"     : "🐸",
        "bee"      : "🐝",
        "buterfly" : "🦋",
        "fish"     : "🐟",
        "panda"    : "🐼",
        "penguin"  : "🐧",
        "bird"     : "🐦",
        "elephant" : "🐘",
        "giraf"    : "🦒",
        "lion"     : "🦁",
        "monkey"   : "🐒",
        "zebra"    : "🦓",
    ]

    var body: some View {
        Group {
            switch item.display {

            case .image(let name):
                if UIImage(named: name) != nil {
                    Image(name)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: size, maxHeight: size)
                } else {
                    // Emoji fallback — shows while asset is unavailable
                    Text(Self.emojiFallback[name] ?? "🐾")
                        .font(.system(size: size * 0.62))
                        .frame(maxWidth: size, maxHeight: size)
                        .minimumScaleFactor(0.4)
                }

            case .emoji(let emoji):
                Text(emoji)
                    .font(.system(size: size * 0.62))
                    .frame(maxWidth: size, maxHeight: size)
                    .minimumScaleFactor(0.4)

            case .solidColor(let color):
                Circle()
                    .fill(color)
                    .frame(maxWidth: size, maxHeight: size)
                    .shadow(color: color.opacity(0.35), radius: size * 0.06)

            case .shape(let kind, let color):
                shapeView(kind: kind, color: color)

            case .letter(let letter, let color):
                Text(letter)
                    .font(.system(size: size * 0.78, weight: .bold, design: .rounded))
                    .foregroundColor(color)
                    .frame(maxWidth: size, maxHeight: size)
                    .minimumScaleFactor(0.3)
                    .shadow(color: color.opacity(0.25), radius: size * 0.03)

            case .number(let n, let color):
                numberView(n: n, color: color)
            }
        }
    }

    // MARK: - Shape

    @ViewBuilder
    private func shapeView(kind: LearningItem.ShapeKind, color: Color) -> some View {
        switch kind {
        case .circle:
            Circle()
                .fill(color)
                .frame(maxWidth: size, maxHeight: size)
                .shadow(color: color.opacity(0.35), radius: size * 0.05)

        case .square:
            RoundedRectangle(cornerRadius: size * 0.10, style: .continuous)
                .fill(color)
                .frame(maxWidth: size, maxHeight: size)
                .shadow(color: color.opacity(0.35), radius: size * 0.05)

        case .triangle:
            TriangleShape()
                .fill(color)
                .frame(maxWidth: size, maxHeight: size * 0.88)
                .shadow(color: color.opacity(0.35), radius: size * 0.05)

        case .star:
            StarShape(points: 5)
                .fill(color)
                .frame(maxWidth: size, maxHeight: size)
                .shadow(color: color.opacity(0.35), radius: size * 0.05)
        }
    }

    // MARK: - Number (numeral + dot grid)

    @ViewBuilder
    private func numberView(n: Int, color: Color) -> some View {
        VStack(spacing: size * 0.04) {
            // Large numeral
            Text("\(n)")
                .font(.system(size: size * 0.55, weight: .bold, design: .rounded))
                .foregroundColor(color)
                .shadow(color: color.opacity(0.25), radius: size * 0.02)

            // Dot grid — max 5 per row
            dotGrid(count: n, color: color)
        }
        .frame(maxWidth: size, maxHeight: size)
    }

    @ViewBuilder
    private func dotGrid(count: Int, color: Color) -> some View {
        let dotSize  : CGFloat = max(size * 0.075, 10)
        let spacing  : CGFloat = dotSize * 0.45
        let perRow   : Int     = 5
        let rows     : Int     = (count + perRow - 1) / perRow

        VStack(spacing: spacing) {
            ForEach(0 ..< rows, id: \.self) { row in
                let dotsInRow = min(perRow, count - row * perRow)
                HStack(spacing: spacing) {
                    ForEach(0 ..< dotsInRow, id: \.self) { _ in
                        Circle()
                            .fill(color.opacity(0.75))
                            .frame(width: dotSize, height: dotSize)
                    }
                }
            }
        }
    }
}

// MARK: - Triangle Shape

struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: .init(x: rect.midX, y: rect.minY))
        p.addLine(to: .init(x: rect.maxX, y: rect.maxY))
        p.addLine(to: .init(x: rect.minX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

// MARK: - Star Shape

struct StarShape: Shape {
    let points: Int
    func path(in rect: CGRect) -> Path {
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let r1 = min(rect.width, rect.height) / 2
        let r2 = r1 * 0.42
        var p  = Path()
        for i in 0 ..< points * 2 {
            let a   = (Double(i) * .pi / Double(points)) - .pi / 2
            let r   = i.isMultiple(of: 2) ? r1 : r2
            let pt  = CGPoint(x: c.x + CGFloat(cos(a)) * r, y: c.y + CGFloat(sin(a)) * r)
            i == 0 ? p.move(to: pt) : p.addLine(to: pt)
        }
        p.closeSubpath()
        return p
    }
}

#Preview {
    VStack(spacing: 20) {
        ItemDisplayView(item: animalsContent[0],  size: 200)
        ItemDisplayView(item: numbersContent[2],  size: 200)
        ItemDisplayView(item: shapesContent[3],   size: 200)
    }
    .padding()
    .background(Color(red: 0.97, green: 0.95, blue: 0.90))
}
