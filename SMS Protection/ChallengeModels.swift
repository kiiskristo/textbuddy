//
//  ChallengeModels.swift
//  SMS Protection
//
//  Created by Kristo Kiis on 11/21/25.
//

import Foundation

// MARK: - Challenge Types

enum ChallengeType: String, Codable {
    case identifyPhishing      // Is this message a scam?
    case spotTheRedFlag        // What's suspicious about this?
    case safeOrDangerous       // Is this link safe?
    case trueFalse             // True/False security facts
    case multipleChoice        // General security knowledge
}

// MARK: - Challenge Model

struct Challenge: Identifiable, Codable {
    let id: UUID
    let type: ChallengeType
    let title: String
    let scenario: String           // The message/situation to evaluate
    let options: [ChallengeOption]
    let correctOptionIndex: Int
    let explanation: String        // Why this is the correct answer
    let difficulty: Difficulty
    let category: ChallengeCategory

    init(id: UUID = UUID(), type: ChallengeType, title: String, scenario: String, options: [ChallengeOption], correctOptionIndex: Int, explanation: String, difficulty: Difficulty, category: ChallengeCategory) {
        self.id = id
        self.type = type
        self.title = title
        self.scenario = scenario
        self.options = options
        self.correctOptionIndex = correctOptionIndex
        self.explanation = explanation
        self.difficulty = difficulty
        self.category = category
    }
}

struct ChallengeOption: Identifiable, Codable {
    let id: UUID
    let text: String

    init(id: UUID = UUID(), text: String) {
        self.id = id
        self.text = text
    }
}

enum Difficulty: String, Codable, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"

    var color: String {
        switch self {
        case .beginner: return "green"
        case .intermediate: return "orange"
        case .advanced: return "red"
        }
    }
}

enum ChallengeCategory: String, Codable, CaseIterable {
    case phishing = "Phishing"
    case passwords = "Passwords"
    case links = "Links & URLs"
    case privacy = "Privacy"
    case socialEngineering = "Social Engineering"

    var icon: String {
        switch self {
        case .phishing: return "envelope.badge.shield.half.filled"
        case .passwords: return "key.fill"
        case .links: return "link"
        case .privacy: return "hand.raised.fill"
        case .socialEngineering: return "person.2.fill"
        }
    }
}

// MARK: - User Progress

struct UserProgress: Codable {
    var completedChallengeIDs: Set<UUID>
    var currentStreak: Int
    var longestStreak: Int
    var totalPoints: Int
    var lastCompletedDate: Date?
    var categoryProgress: [ChallengeCategory: Int]

    init() {
        self.completedChallengeIDs = []
        self.currentStreak = 0
        self.longestStreak = 0
        self.totalPoints = 0
        self.lastCompletedDate = nil
        self.categoryProgress = [:]
    }

    var level: Int {
        totalPoints / 100 + 1
    }

    var pointsToNextLevel: Int {
        100 - (totalPoints % 100)
    }
}

// MARK: - Daily Challenge

struct DailyChallenge {
    let challenge: Challenge
    let date: Date
    var isCompleted: Bool
}
