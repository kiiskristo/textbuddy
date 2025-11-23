//
//  ChallengeManager.swift
//  SMS Protection
//
//  Created by Kristo Kiis on 11/21/25.
//

import Foundation
import SwiftUI

@Observable
class ChallengeManager {
    static let shared = ChallengeManager()

    var progress: UserProgress
    var allChallenges: [Challenge] = []

    private let progressKey = "userProgress"

    init() {
        // Load saved progress
        if let data = UserDefaults.standard.data(forKey: progressKey),
           let savedProgress = try? JSONDecoder().decode(UserProgress.self, from: data) {
            self.progress = savedProgress
        } else {
            self.progress = UserProgress()
        }

        loadChallenges()
        updateStreak()
    }

    // MARK: - Challenge Loading

    private func loadChallenges() {
        // Demo challenges - you'll replace these with real content
        allChallenges = ChallengeContent.challenges
    }

    // MARK: - Daily Challenge

    var todaysChallenge: Challenge? {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let availableChallenges = allChallenges.filter { !progress.completedChallengeIDs.contains($0.id) }

        if availableChallenges.isEmpty {
            // All completed, cycle through again
            let index = dayOfYear % allChallenges.count
            return allChallenges[index]
        }

        let index = dayOfYear % availableChallenges.count
        return availableChallenges[index]
    }

    var isTodayCompleted: Bool {
        guard let lastDate = progress.lastCompletedDate else { return false }
        return Calendar.current.isDateInToday(lastDate)
    }

    // MARK: - Progress Management

    func completeChallenge(_ challenge: Challenge, correct: Bool) {
        progress.completedChallengeIDs.insert(challenge.id)

        if correct {
            let points = pointsForChallenge(challenge)
            progress.totalPoints += points

            // Update category progress
            let current = progress.categoryProgress[challenge.category] ?? 0
            progress.categoryProgress[challenge.category] = current + 1
        }

        // Update streak
        let calendar = Calendar.current
        if let lastDate = progress.lastCompletedDate {
            if calendar.isDateInYesterday(lastDate) {
                progress.currentStreak += 1
            } else if !calendar.isDateInToday(lastDate) {
                progress.currentStreak = 1
            }
        } else {
            progress.currentStreak = 1
        }

        progress.longestStreak = max(progress.longestStreak, progress.currentStreak)
        progress.lastCompletedDate = Date()

        saveProgress()
    }

    private func pointsForChallenge(_ challenge: Challenge) -> Int {
        switch challenge.difficulty {
        case .beginner: return 10
        case .intermediate: return 20
        case .advanced: return 30
        }
    }

    private func updateStreak() {
        guard let lastDate = progress.lastCompletedDate else { return }
        let calendar = Calendar.current

        if !calendar.isDateInToday(lastDate) && !calendar.isDateInYesterday(lastDate) {
            progress.currentStreak = 0
            saveProgress()
        }
    }

    private func saveProgress() {
        if let data = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(data, forKey: progressKey)
        }
    }

    // MARK: - Challenges by Category

    func challenges(for category: ChallengeCategory) -> [Challenge] {
        allChallenges.filter { $0.category == category }
    }

    func completedCount(for category: ChallengeCategory) -> Int {
        progress.categoryProgress[category] ?? 0
    }
}
