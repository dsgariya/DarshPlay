//
//  Analytics.swift
//  TinyGlow
//
//  Centralised Firebase Analytics event logging.
//  All event names and parameter keys are defined here to avoid magic strings.
//

import Foundation
import FirebaseAnalytics

/// Logs structured Firebase Analytics events throughout the app.
enum TinyGlowAnalytics {

    // MARK: - Event Names

    private enum Event {
        static let categoryOpened   = "category_opened"       // user taps a category card
        static let quizStarted      = "quiz_started"          // user taps Quiz on a category
        static let itemViewed       = "item_viewed"           // item appears on learn screen
        static let itemTapped       = "item_tapped"           // child taps item to hear sound
        static let itemSwiped       = "item_swiped"           // child swipes to next/prev item
        static let quizAnswered     = "quiz_answered"         // child picks a quiz answer
        static let calmModeEntered  = "calm_mode_entered"     // calm mode opened
        static let calmModeTapped   = "calm_mode_tapped"      // child taps in calm mode
        static let appSessionStart  = "app_session_start"     // app comes to foreground
    }

    // MARK: - Parameter Keys

    private enum Param {
        static let category   = "category"     // e.g. "animals", "colors"
        static let itemName   = "item_name"    // e.g. "cow", "red"
        static let direction  = "direction"    // "next" or "previous"
        static let isCorrect  = "is_correct"   // "true" / "false"
        static let score      = "score"        // current quiz score
    }

    // MARK: - Public Logging Methods

    /// User taps a category card to start learning.
    static func logCategoryOpened(_ category: ContentCategory) {
        Analytics.logEvent(Event.categoryOpened, parameters: [
            Param.category: category.rawValue
        ])
    }

    /// User taps the Quiz button on a category card.
    static func logQuizStarted(_ category: ContentCategory) {
        Analytics.logEvent(Event.quizStarted, parameters: [
            Param.category: category.rawValue
        ])
    }

    /// An item is displayed on the learn screen (on appear + after swipe).
    static func logItemViewed(_ item: LearningItem, category: ContentCategory) {
        Analytics.logEvent(Event.itemViewed, parameters: [
            Param.category: category.rawValue,
            Param.itemName: item.name
        ])
    }

    /// Child taps the item to hear its sound.
    static func logItemTapped(_ item: LearningItem, category: ContentCategory) {
        Analytics.logEvent(Event.itemTapped, parameters: [
            Param.category: category.rawValue,
            Param.itemName: item.name
        ])
    }

    /// Child swipes to navigate items.
    /// - Parameter direction: `1` = next, `-1` = previous.
    static func logItemSwiped(_ item: LearningItem, category: ContentCategory, direction: Int) {
        Analytics.logEvent(Event.itemSwiped, parameters: [
            Param.category:  category.rawValue,
            Param.itemName:  item.name,
            Param.direction: direction == 1 ? "next" : "previous"
        ])
    }

    /// Child selects a quiz answer.
    static func logQuizAnswered(
        correct: LearningItem,
        tapped: LearningItem,
        category: ContentCategory,
        score: Int
    ) {
        let isCorrect = correct.id == tapped.id
        Analytics.logEvent(Event.quizAnswered, parameters: [
            Param.category:  category.rawValue,
            Param.itemName:  correct.name,
            Param.isCorrect: isCorrect ? "true" : "false",
            Param.score:     score
        ])
    }

    /// User (or parent) enters calm mode.
    static func logCalmModeEntered() {
        Analytics.logEvent(Event.calmModeEntered, parameters: nil)
    }

    /// Child taps anywhere in calm mode.
    static func logCalmModeTapped() {
        Analytics.logEvent(Event.calmModeTapped, parameters: nil)
    }

    /// Called once on first render of ContentView to track active sessions.
    static func logSessionStart() {
        Analytics.logEvent(Event.appSessionStart, parameters: nil)
    }
}
