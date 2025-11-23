//
//  LearnView.swift
//  SMS Protection
//
//  Created by Kristo Kiis on 11/21/25.
//

import SwiftUI

struct LearnView: View {
    @State private var challengeManager = ChallengeManager.shared
    @State private var showingDailyChallenge = false
    @State private var selectedCategory: ChallengeCategory?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Stats Header
                    StatsHeaderView(progress: challengeManager.progress)

                    // Daily Challenge Card
                    DailyChallengeCard(
                        isCompleted: challengeManager.isTodayCompleted,
                        streak: challengeManager.progress.currentStreak
                    ) {
                        showingDailyChallenge = true
                    }

                    // Categories
                    CategoriesSection(
                        challengeManager: challengeManager,
                        selectedCategory: $selectedCategory
                    )

                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("Learn")
            .sheet(isPresented: $showingDailyChallenge) {
                if let challenge = challengeManager.todaysChallenge {
                    ChallengeView(challenge: challenge, challengeManager: challengeManager)
                }
            }
            .sheet(item: $selectedCategory) { category in
                CategoryChallengesView(category: category, challengeManager: challengeManager)
            }
        }
    }
}

// MARK: - Stats Header

struct StatsHeaderView: View {
    let progress: UserProgress

    var body: some View {
        HStack(spacing: 16) {
            StatBox(value: "\(progress.level)", label: "Level", icon: "star.fill", color: .yellow)
            StatBox(value: "\(progress.currentStreak)", label: "Day Streak", icon: "flame.fill", color: .orange)
            StatBox(value: "\(progress.totalPoints)", label: "Points", icon: "bolt.fill", color: .blue)
        }
    }
}

struct StatBox: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}

// MARK: - Daily Challenge Card

struct DailyChallengeCard: View {
    let isCompleted: Bool
    let streak: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "calendar")
                        .font(.title2)
                        .foregroundStyle(isCompleted ? .green : .blue)

                    VStack(alignment: .leading) {
                        Text("Daily Challenge")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(isCompleted ? "Completed! Come back tomorrow" : "Test your security knowledge")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    if !isCompleted {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                }

                if !isCompleted && streak > 0 {
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.orange)
                        Text("Keep your \(streak)-day streak going!")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(isCompleted ? Color.green.opacity(0.1) : Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(isCompleted)
    }
}

// MARK: - Categories Section

struct CategoriesSection: View {
    let challengeManager: ChallengeManager
    @Binding var selectedCategory: ChallengeCategory?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categories")
                .font(.headline)

            ForEach(ChallengeCategory.allCases, id: \.self) { category in
                CategoryRow(
                    category: category,
                    completedCount: challengeManager.completedCount(for: category),
                    totalCount: challengeManager.challenges(for: category).count
                ) {
                    selectedCategory = category
                }
            }
        }
    }
}

struct CategoryRow: View {
    let category: ChallengeCategory
    let completedCount: Int
    let totalCount: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: category.icon)
                    .font(.title3)
                    .foregroundStyle(.blue)
                    .frame(width: 32)

                VStack(alignment: .leading) {
                    Text(category.rawValue)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)

                    Text("\(completedCount)/\(totalCount) completed")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                // Progress ring
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 3)
                    Circle()
                        .trim(from: 0, to: totalCount > 0 ? CGFloat(completedCount) / CGFloat(totalCount) : 0)
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                }
                .frame(width: 24, height: 24)

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
        }
    }
}

// MARK: - Category Extension for Identifiable

extension ChallengeCategory: Identifiable {
    var id: String { rawValue }
}

#Preview {
    LearnView()
}
