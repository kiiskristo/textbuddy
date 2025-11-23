# SMS Protection Setup Guide

## Overview
This guide will help you complete the setup of the SMS Protection app by adding the Message Filter Extension target in Xcode.

## What's Already Done ✅

I've created all the necessary Swift files for the app:

1. **Core Logic** (in `SMS Protection/` folder):
   - `BrandConfiguration.swift` - Defines brands and their legitimate domains
   - `MessageValidator.swift` - Core URL extraction and validation logic
   - `StatsManager.swift` - Statistics tracking via App Group
   - `SecurityTips.swift` - Educational security tips
   - `ContentView.swift` - Updated UI with stats dashboard

2. **Extension Handler**:
   - `MessageFilterExtension.swift` - Ready to be added to the extension target

3. **Tests**:
   - `SMS_ProtectionTests.swift` - Comprehensive unit tests for the validation logic

## What You Need to Do in Xcode

### Step 1: Add App Groups Capability

1. Open `SMS Protection.xcodeproj` in Xcode
2. Select the `SMS Protection` target
3. Go to **Signing & Capabilities** tab
4. Click **+ Capability** and add **App Groups**
5. Click the **+** button under App Groups and add: `group.com.bdcapps.SMS-Protection`

### Step 2: Create Message Filter Extension Target

1. In Xcode, go to **File → New → Target**
2. Choose **iOS** → **Message Filter Extension**
3. Name it: `SMS Protection Filter` (or similar)
4. Product Name: `SMS Protection Filter`
5. Language: **Swift**
6. Click **Finish**
7. When asked to activate the scheme, click **Activate**

### Step 3: Configure the Extension Target

1. Select the new extension target in the project navigator
2. Go to **Signing & Capabilities**
3. Click **+ Capability** and add **App Groups**
4. Add the same App Group: `group.com.bdcapps.SMS-Protection`

### Step 4: Add Files to Extension Target

The extension needs access to the shared logic files:

1. Select the following files in the Project Navigator:
   - `BrandConfiguration.swift`
   - `MessageValidator.swift`
   - `StatsManager.swift`

2. For each file, open the **File Inspector** (right panel)
3. Under **Target Membership**, check the box for your extension target

### Step 5: Replace Extension Implementation

1. Find the extension's main file (usually `MessageFilterExtension.swift` in the extension folder)
2. Replace its contents with the file I created at the root: `/MessageFilterExtension.swift`
3. Or copy the implementation manually

### Step 6: Update Extension Info.plist

The extension's Info.plist should already be configured by Xcode, but verify:

- `NSExtension` dictionary should have:
  - `NSExtensionPointIdentifier`: `com.apple.identitylookup.message-filter`
  - `NSExtensionPrincipalClass`: `$(PRODUCT_MODULE_NAME).MessageFilterExtension`

### Step 7: Build and Run

1. Select the main **SMS Protection** scheme (not the extension scheme)
2. Choose a simulator or device
3. Build and run the app (⌘R)
4. The app should launch showing the stats dashboard

## Testing the Extension

### On a Physical Device:

1. Install the app on your iPhone
2. Go to **Settings → Messages → Unknown & Spam**
3. Enable **Filter Unknown Senders**
4. Select **SMS Protection** from the list
5. Send yourself test SMS messages with suspicious URLs

### Test Messages:

**Legitimate (should NOT be filtered):**
```
Your package is ready: https://track.ups.com/123456
```

**Suspicious (should be filtered as junk):**
```
Your FedEx package is waiting: https://fedex-verify.suspicious-site.com/track
```

### On Simulator:

Note: The simulator cannot receive real SMS messages, so you can't fully test the filtering. However, you can:

1. Run the unit tests to verify the logic works
2. Test the UI and stats display
3. Use the Stats Manager's `recordMessageChecked()` method to simulate messages

## Verifying It Works

1. Open the SMS Protection app
2. Check that the UI displays correctly with stats at 0
3. Send test messages (on device only)
4. Open the app again - you should see updated statistics
5. The "Today's Safety Tip" should rotate daily

## Troubleshooting

### Extension Not Appearing in Settings
- Make sure both the app and extension have the same App Group ID
- Verify the extension's Info.plist is configured correctly
- Try deleting the app and reinstalling

### Stats Not Updating
- Verify both targets have the App Group capability
- Check that the App Group ID matches exactly in both targets
- The App Group must be: `group.com.bdcapps.SMS-Protection`

### Build Errors
- Ensure all shared files are added to both targets
- Check that IdentityLookup framework is linked to the extension
- Verify Swift version compatibility

## Running Unit Tests

To run the tests:
```bash
xcodebuild test -scheme "SMS Protection" -destination 'platform=iOS Simulator,name=iPhone 17'
```

Or in Xcode: **Product → Test** (⌘U)

## Next Steps

Once everything is working:

1. Test with real phishing messages (if you have any)
2. Consider adding more brands to `BrandConfiguration.swift`
3. Add more security tips to `SecurityTips.swift`
4. Consider adding settings to enable/disable specific brands
5. Test on multiple iOS versions if needed

## Architecture Notes

- **On-device processing**: All message analysis happens locally
- **Privacy-first**: No data leaves the device
- **Lightweight**: Uses simple string matching for fast processing
- **Extensible**: Easy to add more brands or validation rules

## Need Help?

- Check the `CLAUDE.md` file for development commands
- Review the `Description.md` file for project requirements
- Unit tests in `SMS_ProtectionTests.swift` show expected behavior
