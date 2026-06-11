# App Store Connect — Darsh Play Listing Guide

Use this file as a reference when filling in App Store Connect.
Everything marked with a code block is ready to copy-paste directly.

---

## 1. App Name

```
Darsh Play
```

---

## 2. Subtitle
_(max 30 characters — shown under the app name in search results)_

```
Learn, Play & Grow Together
```

---

## 3. Description
_(max 4000 characters — shown on the App Store product page)_

```
Darsh Play is a calm, screen-safe learning app made for toddlers and young children (ages 1–4). Designed with simplicity in mind — no distractions, no ads, no pressure. Just tap, listen, and learn.

TAP & HEAR
Tap any animal, letter, number, colour or shape to hear its name and sound. Simple, clear, and satisfying for little hands.

5 LEARNING CATEGORIES
• 🐾 Animals — 18 animals with their sounds (Moo, Meow, Roar and more)
• 🔤 ABC — All 26 letters in bright, bold colours
• 123 Numbers — Count from 1 to 10 with visual dot grids
• 🎨 Colors — 7 vibrant colours to learn and recognise
• ⬟ Shapes — Circle, Square, Triangle and Star

QUIZ MODE
After exploring, switch to Quiz Mode! Four picture choices appear — tap the right one to earn a celebration burst of stars. A fun way to reinforce what your child has just learned.

CALM MODE
A gentle dark screen with soft glowing sparkles. Perfect for winding down or soothing a restless toddler.

PARENT CONTROLS
A hidden settings area (tap the gear icon) lets parents:
• Switch between learning categories
• Toggle sound on or off
• Switch between Learn and Calm mode
• Return to the home screen

SAFE FOR CHILDREN
✓ No ads
✓ No in-app purchases
✓ No accounts or sign-up required
✓ No personal data collected
✓ No internet connection required to learn
✓ COPPA compliant
```

---

## 4. Keywords
_(max 100 characters, comma-separated — used for App Store search ranking)_

```
toddler,baby,learn,animals,abc,numbers,colors,shapes,kids,educational,phonics,calm
```

---

## 5. Support URL
_(must be a working URL — links to your GitHub repo)_

```
https://github.com/dsgariya/DarshPlay
```

---

## 6. Privacy Policy URL
_(required for apps targeting children — must be live before submission)_

```
https://dsgariya.github.io/DarshPlay/PRIVACY_POLICY
```

> **Note:** This URL only works if GitHub Pages is enabled on the repo.
> Go to: GitHub repo → Settings → Pages → Source: Deploy from branch → Branch: main → Save.

---

## 7. App Category

- **Primary:** Education
- **Secondary:** Games → Educational (optional)

---

## 8. Age Rating

Answer the questionnaire in App Store Connect as follows:

| Question | Answer |
|---|---|
| Cartoon or Fantasy Violence | None |
| Realistic Violence | None |
| Sexual Content | None |
| Profanity | None |
| Alcohol, Tobacco, Drugs | None |
| Gambling | None |
| Horror/Fear | None |
| Medical/Treatment info | None |
| Made for Kids (COPPA) | **Yes** |

**Expected result: 4+**

---

## 9. Pricing

- **Price:** Free

---

## 10. Screenshots Required

Apple requires screenshots for specific device sizes.
Take these in Xcode Simulator — **Product → Screenshot** or `Cmd+S`.

### Devices to Screenshot

| Device | Simulator Name | Size | Status |
|---|---|---|---|
| iPhone 6.9" | iPhone 16 Pro Max | 1320 × 2868 px | Required |
| iPhone 6.5" | iPhone 11 Pro Max | 1242 × 2688 px | Required |
| iPad 13" | iPad Pro 13-inch (M4) | 2064 × 2752 px | Optional |

### 5 Screens to Capture (on each device)

Capture these screens in order. You can add short text overlays later in Canva or directly in App Store Connect.

| # | Screen | How to get there | Suggested overlay text |
|---|---|---|---|
| 1 | Home screen — all 5 category cards visible | Launch app, wait for home | "5 Fun Ways to Learn" |
| 2 | Animals learn mode — Elephant or Lion | Tap Animals → swipe to Elephant | "Tap & Hear Every Animal" |
| 3 | Quiz mode — 4-choice question showing | Tap Animals → Quiz → start | "Quiz Time Makes It Stick" |
| 4 | Correct answer — celebration burst visible | Answer a quiz question correctly | "Every Win Gets a Cheer!" |
| 5 | ABC or Numbers learn screen | Tap ABC from home | "Letters, Numbers & More" |

### Screenshot Tips
- Hide the status bar (it's already hidden in the app)
- Use light, bright screens — avoid dark backgrounds for the main shots
- Keep Calm Mode screenshot as a bonus 6th if you want to show variety

---

## 11. App Icon

Make sure your app icon set is complete before submitting.
Required sizes (all must be in `Assets.xcassets/AppIcon.appiconset`):

| Size | Usage |
|---|---|
| 1024 × 1024 px | App Store listing (required) |
| 180 × 180 px | iPhone @3x |
| 120 × 120 px | iPhone @2x |
| 167 × 167 px | iPad Pro @2x |
| 152 × 152 px | iPad @2x |
| 87 × 87 px | iPhone @3x small |
| 80 × 80 px | iPhone/iPad @2x small |
| 58 × 58 px | iPhone/iPad @2x settings |
| 40 × 40 px | iPhone/iPad @1x spotlight |

> **Tip:** Use [appicon.co](https://www.appicon.co) — upload your 1024×1024 and it generates all sizes automatically.

---

## 12. What to Do in Order

- [ ] 1. Enable GitHub Pages on the repo (for the privacy policy URL to work)
- [ ] 2. Generate full app icon set from your 1024×1024 using appicon.co
- [ ] 3. Take screenshots on iPhone 16 Pro Max simulator
- [ ] 4. Take screenshots on iPhone 11 Pro Max simulator
- [ ] 5. Log in to App Store Connect → My Apps → + New App
- [ ] 6. Fill in Name, Subtitle, Bundle ID (`com.devgariya.gariya.darshplay`), SKU (e.g. `darshplay-001`)
- [ ] 7. Paste Description, Keywords, Support URL, Privacy Policy URL from above
- [ ] 8. Upload screenshots for each device size
- [ ] 9. Complete the Age Rating questionnaire (select "Made for Kids")
- [ ] 10. Set price to Free
- [ ] 11. Upload build from Xcode → Product → Archive → Distribute App
- [ ] 12. Submit for review
