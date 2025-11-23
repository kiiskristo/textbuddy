//
//  ChallengeContent.swift
//  SMS Protection
//
//  Created by Kristo Kiis on 11/21/25.
//

import Foundation

// MARK: - Demo Challenge Content
// Replace these with your real content

enum ChallengeContent {
    static let challenges: [Challenge] = [
        // MARK: - Phishing Challenges

        Challenge(
            type: .identifyPhishing,
            title: "Spot the Scam",
            scenario: "\"URGENT: Your Apple ID has been compromised! Click here to verify: http://apple-id-secure.net/verify\"",
            options: [
                ChallengeOption(text: "This is legitimate"),
                ChallengeOption(text: "This is a scam")
            ],
            correctOptionIndex: 1,
            explanation: "This is a phishing scam. Apple would never send urgent messages with suspicious links. The domain 'apple-id-secure.net' is not Apple's real domain (apple.com).",
            difficulty: .beginner,
            category: .phishing
        ),

        Challenge(
            type: .identifyPhishing,
            title: "Package Delivery",
            scenario: "\"UPS: Your package could not be delivered. Reschedule at: http://ups.com/redelivery/12345\"",
            options: [
                ChallengeOption(text: "This is legitimate"),
                ChallengeOption(text: "This is a scam")
            ],
            correctOptionIndex: 0,
            explanation: "This appears legitimate. The link uses the official ups.com domain. However, always verify by going directly to ups.com instead of clicking links.",
            difficulty: .intermediate,
            category: .phishing
        ),

        Challenge(
            type: .spotTheRedFlag,
            title: "Find the Red Flag",
            scenario: "\"Your Netflix subscription expires today! Update payment at netf1ix-billing.com to avoid interruption.\"",
            options: [
                ChallengeOption(text: "Urgency language"),
                ChallengeOption(text: "Misspelled domain (netf1ix)"),
                ChallengeOption(text: "Mentions payment"),
                ChallengeOption(text: "All of the above")
            ],
            correctOptionIndex: 3,
            explanation: "All are red flags! The urgency creates pressure, 'netf1ix' uses a '1' instead of 'l' to look like Netflix, and requesting payment info is a classic scam tactic.",
            difficulty: .beginner,
            category: .phishing
        ),

        // MARK: - Links & URLs

        Challenge(
            type: .safeOrDangerous,
            title: "Check This Link",
            scenario: "Which link is the real PayPal website?",
            options: [
                ChallengeOption(text: "paypal.com.secure-login.net"),
                ChallengeOption(text: "www.paypal.com"),
                ChallengeOption(text: "paypa1.com"),
                ChallengeOption(text: "secure-paypal.com")
            ],
            correctOptionIndex: 1,
            explanation: "Only www.paypal.com is real. The others use tricks: adding words after .com, replacing 'l' with '1', or putting 'paypal' after a hyphen.",
            difficulty: .beginner,
            category: .links
        ),

        Challenge(
            type: .safeOrDangerous,
            title: "URL Inspection",
            scenario: "You receive: \"Bank of America alert: http://bankofamerica.com.verify-account.ru/login\"",
            options: [
                ChallengeOption(text: "Safe - it has bankofamerica.com"),
                ChallengeOption(text: "Dangerous - the real domain is .ru")
            ],
            correctOptionIndex: 1,
            explanation: "This is dangerous! The actual domain is 'verify-account.ru' (Russian). 'bankofamerica.com' is just a subdomain used to trick you. Always look at what comes right before the first single slash.",
            difficulty: .intermediate,
            category: .links
        ),

        // MARK: - Social Engineering

        Challenge(
            type: .multipleChoice,
            title: "Social Engineering",
            scenario: "Someone calls claiming to be from Microsoft, saying your computer has a virus and they need remote access to fix it. What should you do?",
            options: [
                ChallengeOption(text: "Give them access to help"),
                ChallengeOption(text: "Hang up - Microsoft doesn't call"),
                ChallengeOption(text: "Ask for their employee ID"),
                ChallengeOption(text: "Call them back to verify")
            ],
            correctOptionIndex: 1,
            explanation: "Hang up immediately. Microsoft never makes unsolicited calls about computer problems. This is a common tech support scam to steal your data or money.",
            difficulty: .beginner,
            category: .socialEngineering
        ),

        // MARK: - Passwords

        Challenge(
            type: .trueFalse,
            title: "Password Security",
            scenario: "A longer password with random words like 'correct-horse-battery-staple' is more secure than a short complex one like 'P@ss1!'",
            options: [
                ChallengeOption(text: "True"),
                ChallengeOption(text: "False")
            ],
            correctOptionIndex: 0,
            explanation: "True! Length beats complexity. 'correct-horse-battery-staple' has much more entropy and is easier to remember than short complex passwords.",
            difficulty: .intermediate,
            category: .passwords
        ),

        Challenge(
            type: .multipleChoice,
            title: "Password Best Practice",
            scenario: "What's the BEST way to manage your passwords?",
            options: [
                ChallengeOption(text: "Use the same strong password everywhere"),
                ChallengeOption(text: "Write them in a notebook"),
                ChallengeOption(text: "Use a password manager"),
                ChallengeOption(text: "Use variations of one password")
            ],
            correctOptionIndex: 2,
            explanation: "A password manager generates and stores unique, strong passwords for every site. If one site is breached, your other accounts stay safe.",
            difficulty: .beginner,
            category: .passwords
        ),

        // MARK: - Privacy

        Challenge(
            type: .trueFalse,
            title: "Privacy Check",
            scenario: "Public WiFi at coffee shops is safe to use for online banking if the website shows a padlock (HTTPS).",
            options: [
                ChallengeOption(text: "True"),
                ChallengeOption(text: "False")
            ],
            correctOptionIndex: 1,
            explanation: "False! While HTTPS encrypts your connection, public WiFi can still expose you to various attacks. Use mobile data or a VPN for sensitive activities.",
            difficulty: .intermediate,
            category: .privacy
        ),

        Challenge(
            type: .multipleChoice,
            title: "Data Privacy",
            scenario: "A website offers a free service but asks for your SSN to 'verify your identity'. What should you do?",
            options: [
                ChallengeOption(text: "Provide it - they need to verify"),
                ChallengeOption(text: "Give a fake SSN"),
                ChallengeOption(text: "Never provide SSN to free services"),
                ChallengeOption(text: "Only if it's a big company")
            ],
            correctOptionIndex: 2,
            explanation: "Legitimate free services never need your SSN. This is either identity theft or an unnecessary data collection. Social Security numbers should only be shared with employers, financial institutions, and government agencies.",
            difficulty: .beginner,
            category: .privacy
        ),
    ]
}
