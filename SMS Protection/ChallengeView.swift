//
//  ChallengeView.swift
//  SMS Protection
//
//  Created by Kristo Kiis on 11/21/25.
//

import SwiftUI

struct ChallengeView: View {
    let challenge: Challenge
    let challengeManager: ChallengeManager

    @Environment(\.dismiss) private var dismiss
    @State private var selectedOptionIndex: Int?
    @State private var hasSubmitted = false
    @State private var showingResult = false

    private var isCorrect: Bool {
        selectedOptionIndex == challenge.correctOptionIndex
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Challenge Header
                    VStack(spacing: 8) {
                        HStack {
                            Text(challenge.category.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Capsule())

                            Text(challenge.difficulty.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(difficultyColor.opacity(0.1))
                                .foregroundStyle(difficultyColor)
                                .clipShape(Capsule())
                        }

                        Text(challenge.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }

                    // Scenario
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Scenario")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)

                        Text(challenge.scenario)
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    // Options
                    VStack(spacing: 12) {
                        ForEach(Array(challenge.options.enumerated()), id: \.element.id) { index, option in
                            OptionButton(
                                text: option.text,
                                isSelected: selectedOptionIndex == index,
                                isCorrect: hasSubmitted && index == challenge.correctOptionIndex,
                                isWrong: hasSubmitted && selectedOptionIndex == index && !isCorrect,
                                isDisabled: hasSubmitted
                            ) {
                                if !hasSubmitted {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedOptionIndex = index
                                    }
                                }
                            }
                        }
                    }

                    // Submit Button
                    if !hasSubmitted {
                        Button {
                            submitAnswer()
                        } label: {
                            Text("Check Answer")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(selectedOptionIndex != nil ? Color.blue : Color.gray)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(selectedOptionIndex == nil)
                    }

                    // Result & Explanation
                    if hasSubmitted {
                        ResultCard(isCorrect: isCorrect, explanation: challenge.explanation)

                        Button {
                            dismiss()
                        } label: {
                            Text("Continue")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }

                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var difficultyColor: Color {
        switch challenge.difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }

    private func submitAnswer() {
        withAnimation {
            hasSubmitted = true
        }
        challengeManager.completeChallenge(challenge, correct: isCorrect)
    }
}

// MARK: - Option Button

struct OptionButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isWrong: Bool
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)

                Spacer()

                if isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                } else if isWrong {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.red)
                } else if isSelected {
                    Image(systemName: "circle.fill")
                        .foregroundStyle(.blue)
                        .font(.caption)
                } else {
                    Image(systemName: "circle")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
            }
            .padding()
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: isSelected || isCorrect || isWrong ? 2 : 1)
            )
        }
        .disabled(isDisabled)
    }

    private var backgroundColor: Color {
        if isCorrect {
            return Color.green.opacity(0.1)
        } else if isWrong {
            return Color.red.opacity(0.1)
        } else if isSelected {
            return Color.blue.opacity(0.1)
        }
        return Color(.systemBackground)
    }

    private var borderColor: Color {
        if isCorrect {
            return .green
        } else if isWrong {
            return .red
        } else if isSelected {
            return .blue
        }
        return Color(.systemGray4)
    }
}

// MARK: - Result Card

struct ResultCard: View {
    let isCorrect: Bool
    let explanation: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(isCorrect ? .green : .red)

                Text(isCorrect ? "Correct!" : "Not quite right")
                    .font(.headline)
                    .foregroundStyle(isCorrect ? .green : .red)
            }

            Text(explanation)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(isCorrect ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Category Challenges View

struct CategoryChallengesView: View {
    let category: ChallengeCategory
    let challengeManager: ChallengeManager

    @Environment(\.dismiss) private var dismiss
    @State private var selectedChallenge: Challenge?

    var challenges: [Challenge] {
        challengeManager.challenges(for: category)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(challenges) { challenge in
                    Button {
                        selectedChallenge = challenge
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(challenge.title)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.primary)

                                Text(challenge.difficulty.rawValue)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            if challengeManager.progress.completedChallengeIDs.contains(challenge.id) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                        }
                    }
                }
            }
            .navigationTitle(category.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(item: $selectedChallenge) { challenge in
                ChallengeView(challenge: challenge, challengeManager: challengeManager)
            }
        }
    }
}

// MARK: - Challenge Extension for Identifiable sheet

extension Challenge: Hashable {
    static func == (lhs: Challenge, rhs: Challenge) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

#Preview {
    ChallengeView(
        challenge: ChallengeContent.challenges[0],
        challengeManager: ChallengeManager.shared
    )
}
