# Darsh Play 🎓

A toddler-friendly educational iOS app that helps babies and young children learn **Animals**, **Colors**, **Shapes**, **Numbers**, and the **ABC** — through tapping, swiping, and a fun quiz mode.

---

## Features

| Mode | Description |
|---|---|
| **Learn** | Swipe through illustrated cards; tap to hear the name/sound |
| **Quiz** | 4-choice picture quiz with celebration animation and score tracking |
| **Calm Mode** | Dark night-sky screen with soft sparkles on tap — ideal for winding down |
| **Parent Settings** | Gear button opens category picker, mode switcher, and sound toggle |

### Categories
- 🐾 **Animals** — 18 illustrated animals with their sounds (e.g. Cow → Moo)
- 🎨 **Colors** — solid colour circles with names
- 🔷 **Shapes** — circle, square, triangle, star
- 🔢 **Numbers** — numerals 1–10 with dot grids
- 🔤 **ABC** — all 26 letters A–Z

---

## Screenshots

> _(Add screenshots here)_

---

## Tech Stack

- **SwiftUI** — 100% declarative UI, no storyboards
- **AVFoundation / AVSpeechSynthesizer** — text-to-speech for item names & sounds
- **Firebase Analytics** — anonymous usage analytics
- **Firebase Crashlytics** — crash reporting
- **Swift Package Manager** — dependency management

### Requirements
- iOS 16.0+
- Xcode 15+
- Swift 5.9+

---

## Project Structure

```
TinyGlow/
├── TinyGlowApp.swift          # App entry point, splash logic
├── ContentView.swift          # Root navigator (Home → Learn / Quiz / Calm)
├── HomeView.swift             # Category grid home screen
├── ItemDisplayView.swift      # Renders a single learning item (image/emoji/shape/colour/letter/number)
├── QuizView.swift             # Quiz mode with 4-choice grid
├── CalmModeView.swift         # Calm/night mode with sparkle particles
├── ParentControlsView.swift   # Parent settings sheet
├── SplashView.swift           # Branded splash screen
├── AudioManager.swift         # TTS + chime audio
├── Models.swift               # Data models, content arrays, AppSettings
└── Assets.xcassets/           # App icon, animal images, category icons, colours
```

---

## Getting Started

1. Clone the repo
   ```bash
   git clone https://github.com/dsgariya/DarshPlay.git
   ```
2. Open `TinyGlow.xcodeproj` in Xcode 15+
3. Select your development team in **Signing & Capabilities**
4. Add your `GoogleService-Info.plist` from the [Firebase Console](https://console.firebase.google.com) to `TinyGlow/`
5. Build and run on a device or simulator (iOS 16+)

---

## Privacy

Darsh Play does not collect any personally identifiable information. Anonymous analytics events are sent to Firebase to help improve the app. See [PRIVACY_POLICY.md](PRIVACY_POLICY.md) for full details.

---

## License

Private — all rights reserved. © 2025 Darsh Play.
