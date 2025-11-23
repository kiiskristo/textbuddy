//
//  ContentView.swift
//  SMS Protection
//
//  Created by Kristo Kiis on 11/21/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Protection", systemImage: "shield.checkered")
                }

            LearnView()
                .tabItem {
                    Label("Learn", systemImage: "brain.head.profile")
                }
        }
    }
}

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Status Header
                    StatusHeaderView()

                    // AI Protection Info
                    AIProtectionView()

                    // Security Tip
                    SecurityTipView()

                    // How to Enable Section
                    HowToEnableView()

                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("TextBuddy")
        }
    }
}

struct StatusHeaderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "shield.checkered")
                .font(.system(size: 60))
                .foregroundStyle(.green)

            Text("Protection Active")
                .font(.title2)
                .fontWeight(.semibold)

            Text("We're checking your text messages for risky links that pretend to be real companies.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}

struct AIProtectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundStyle(.purple)
                Text("AI-Powered Protection")
                    .font(.headline)
            }

            Text("Our machine learning model analyzes URLs in your messages to detect phishing attempts and malicious links.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 16) {
                FeatureItem(icon: "link.badge.plus", text: "URL Analysis")
                FeatureItem(icon: "shield.lefthalf.filled", text: "Phishing Detection")
                FeatureItem(icon: "bolt.fill", text: "Real-time")
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}

struct FeatureItem: View {
    let icon: String
    let text: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.purple)
            Text(text)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct SecurityTipView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(.yellow)
                Text("Today's Safety Tip")
                    .font(.headline)
            }

            Text(SecurityTips.tipOfTheDay)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}

struct HowToEnableView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(.blue)
                Text("How to Enable")
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("To activate SMS filtering:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 4) {
                    Text("1. Open Settings app")
                    Text("2. Go to Messages → Unknown & Spam")
                    Text("3. Enable SMS Filtering")
                    Text("4. Select 'SMS Protection'")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.leading, 8)

                Image("MessagesSettings")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}

#Preview {
    ContentView()
}
