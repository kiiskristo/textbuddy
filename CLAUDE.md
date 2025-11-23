# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an iOS SMS phishing (smishing) filter application built with SwiftUI targeting iOS 26.1+. The app protects users from brand impersonation scams by detecting fake delivery and banking links in SMS messages.

**Key Features:**
- Detects fake brand links (UPS, FedEx, DHL, banks, Robinhood, PayPal, etc.)
- All analysis happens on-device (privacy-first, no data leaves the phone)
- Targets older/less technical users who are vulnerable to SMS phishing
- Shows stats and provides educational security tips

**Architecture:**
- **Message Filter Extension**: Uses iOS IdentityLookup framework to analyze incoming SMS
- **Companion App**: Displays statistics and educational content
- **App Group**: Shares data (counters) between the extension and main app

## Core Algorithm: Brand-Domain Heuristic

The filter uses a simple but effective domain-based approach:

1. Extract all URLs from incoming SMS message body
2. For each URL, parse the host (domain)
3. Check against brand configuration list:
   - Each brand has a `keyword` (e.g., "ups", "fedex", "robinhood") and `allowedDomains` (e.g., ["ups.com"])
   - A domain is **allowed** if it equals or ends with `"." + allowedDomain` (e.g., `track.fedex.com` is allowed for `fedex.com`)
   - If host contains brand keyword BUT is NOT in allowed domains → mark as **suspicious**
4. If any URL is suspicious, classify message as `.junk`, otherwise `.allow`

**Examples:**
- `https://track.fedex.com/123` → ✅ allowed
- `https://fedex.scamstuff.com/track` → ❌ suspicious (contains "fedex" but not on fedex.com)
- `https://www-robinhood.hiefxlyf.wang/Verify` → ❌ suspicious

## Project Structure

**Current structure:**
- **SMS Protection/**: Main application source code
  - `SMS_ProtectionApp.swift`: App entry point using SwiftUI's `@main` attribute
  - `ContentView.swift`: Root view of the application
- **SMS ProtectionTests/**: Unit tests using Swift Testing framework
- **SMS ProtectionUITests/**: UI tests using XCTest framework

**To be implemented:**
- **Message Filter Extension target**: `ILMessageFilterExtension` implementation
- **Brand configuration**: Swift struct with brand keywords and allowed domains
- **URL parser**: Utility to extract and validate URLs against brand config
- **App Group**: Shared UserDefaults for counters (`total_messages_checked`, `total_suspicious_detected`)
- **Stats UI**: Dashboard showing protection status, message counts, and rotating security tips

## Build Commands

### Build the app
```bash
xcodebuild -scheme "SMS Protection" -configuration Debug build
```

### Build for Release
```bash
xcodebuild -scheme "SMS Protection" -configuration Release build
```

### Run Unit Tests
```bash
xcodebuild test -scheme "SMS Protection" -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

### Run Specific Test
```bash
xcodebuild test -scheme "SMS Protection" -destination 'platform=iOS Simulator,name=iPhone 16 Pro' -only-testing:SMS_ProtectionTests/SMS_ProtectionTests/example
```

### Run UI Tests
```bash
xcodebuild test -scheme "SMS Protection" -destination 'platform=iOS Simulator,name=iPhone 16 Pro' -only-testing:SMS_ProtectionUITests
```

### Clean Build
```bash
xcodebuild -scheme "SMS Protection" clean
```

## Testing Framework

This project uses two testing frameworks:
- **Swift Testing**: For unit tests (SMS ProtectionTests target) - uses `@Test` macro
- **XCTest**: For UI tests (SMS ProtectionUITests target) - uses `XCTestCase`

## Development Notes

- Deployment target is iOS 26.1
- Swift concurrency is enabled with main actor isolation by default (`SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`)
- Development team ID: G64X4LJMLZ
- Project uses string catalogs for localization

## Required iOS Setup

### Entitlements & Capabilities
- **App Groups**: Required for sharing data between main app and extension
  - Suggested ID: `group.com.bdcapps.SMS-Protection`
- **SMS and Call Reporting**: Extension capability in Info.plist

### User Setup (After Installation)
Users must manually enable the filter:
1. Settings → Messages → Unknown & Spam
2. Toggle on "SMS Filtering" and select "SMS Protection"

## Implementation Guidelines

### Message Filter Extension
- Implement `ILMessageFilterQueryHandling` protocol
- Use `offlineAction(for:)` for synchronous, on-device processing
- Access message via `queryRequest.messageBody` and `queryRequest.sender`
- Return `ILMessageFilterAction` (`.allow`, `.junk`, or `.none`)
- Keep processing lightweight (extension has strict memory/time limits)

### App Group Data Sharing
Use shared `UserDefaults`:
```swift
let defaults = UserDefaults(suiteName: "group.com.bdcapps.SMS-Protection")
defaults?.integer(forKey: "total_messages_checked")
```

### Brand Configuration
Hardcoded list for MVP, but use clean Swift structs:
```swift
struct Brand {
    let keyword: String
    let allowedDomains: [String]
}
```

Suggested brands: UPS, FedEx, DHL, USPS, PayPal, Venmo, Robinhood, Chase, Bank of America, Wells Fargo, Apple, Amazon

### Stats to Track
- `total_messages_checked`: Incremented for every message processed
- `total_suspicious_detected`: Incremented when message is marked as junk
- Optional: `total_us_numbers_checked`, `total_non_us_numbers_checked` (based on sender prefix)

### Companion App UI
Single screen with:
- Status indicator ("🟢 Protection is ON")
- Stats display (messages checked, suspicious blocked)
- Rotating security tips (10-20 hardcoded tips, rotate by day or launch count)
- Optional settings toggles

**Sample Security Tips:**
- "Don't tap delivery links from random numbers. Open the official app instead."
- "Real companies won't ask you to verify account info via text message."
- "If a link looks suspicious, it probably is. When in doubt, don't click."

## Privacy & Security

- All message analysis happens on-device
- No messages or metadata are sent to any server
- The extension cannot access historical messages, only new incoming SMS
- The main app cannot read message contents, only aggregated statistics
