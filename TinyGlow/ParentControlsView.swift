//
//  ParentControlsView.swift
//  TinyGlow
//
//  Hidden settings sheet triggered by a 2-finger long press.
//  Parent picks category, toggles sound, switches mode, or goes back to home.
//

import SwiftUI

struct ParentControlsView: View {

    @ObservedObject var settings : AppSettings
    @ObservedObject var audio    : AudioManager
    var onGoHome                 : (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {

                // MARK: Content
                Section("Content") {
                    ForEach(ContentCategory.allCases) { category in
                        Button {
                            settings.selectedCategory = category
                            settings.isInCalmMode     = false
                            dismiss()
                        } label: {
                            HStack {
                                Text(category.icon).font(.title2)
                                Text(category.rawValue).foregroundColor(.primary)
                                Spacer()
                                if settings.selectedCategory == category && !settings.isInCalmMode {
                                    Image(systemName: "checkmark").foregroundColor(.accentColor)
                                }
                            }
                        }
                    }
                }

                // MARK: Mode
                Section("Mode") {
                    Button {
                        settings.isInCalmMode = false
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "hand.tap")
                            Text("Tap & Learn").foregroundColor(.primary)
                            Spacer()
                            if !settings.isInCalmMode {
                                Image(systemName: "checkmark").foregroundColor(.accentColor)
                            }
                        }
                    }

                    Button {
                        settings.isInCalmMode = true
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "moon.stars")
                            Text("Calm Mode").foregroundColor(.primary)
                            Spacer()
                            if settings.isInCalmMode {
                                Image(systemName: "checkmark").foregroundColor(.accentColor)
                            }
                        }
                    }
                }

                // MARK: Sound
                Section("Sound") {
                    Toggle("Sound On", isOn: $settings.isSoundEnabled)
                }

                // MARK: Navigation
                if let goHome = onGoHome {
                    Section {
                        Button {
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                goHome()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "house")
                                Text("Back to Home Screen").foregroundColor(.primary)
                            }
                        }
                    }
                }

                // MARK: Dismiss
                Section {
                    Button("Done", role: .cancel) { dismiss() }
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Parent Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ParentControlsView(settings: AppSettings(), audio: AudioManager())
}
