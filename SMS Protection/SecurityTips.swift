//
//  SecurityTips.swift
//  SMS Protection
//
//  Educational security tips for users
//

import Foundation

struct SecurityTips {
    static let tips: [String] = [
        "Don't tap delivery links from random numbers. Open the official app or website instead.",
        "Real companies won't ask you to verify account info via text message.",
        "If a link looks suspicious, it probably is. When in doubt, don't click.",
        "Check the sender's number. Banks and delivery companies use consistent numbers.",
        "Never share passwords, PINs, or verification codes via text.",
        "Be extra careful with messages that create urgency like 'Act now!' or 'Account suspended!'",
        "Legitimate companies rarely send links in text messages. They'll ask you to log in directly.",
        "If you receive an unexpected package notification, check the official app first.",
        "Scammers often use shortened URLs to hide the real destination. Be cautious.",
        "Your bank will never ask you to 'verify' or 'confirm' your account via text link.",
        "When in doubt, call the company directly using the number on their official website.",
        "Real delivery notifications include tracking numbers you can verify on the official site.",
        "Be suspicious of texts with misspelled words or poor grammar.",
        "Protect elderly family members by helping them enable SMS filtering.",
        "If a deal seems too good to be true in a text message, it's probably a scam.",
    ]

    /// Returns a tip based on the current day (rotates daily)
    static var tipOfTheDay: String {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = dayOfYear % tips.count
        return tips[index]
    }

    /// Returns a random tip
    static var randomTip: String {
        tips.randomElement() ?? tips[0]
    }
}
