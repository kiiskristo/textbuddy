# TextBuddy

An iOS SMS filtering app that uses machine learning to detect phishing URLs in text messages.

## Features

- **AI-Powered Detection** - Uses an ONNX machine learning model to analyze URLs for phishing attempts
- **Real-time Filtering** - Integrates with iOS Message Filter Extension to automatically filter suspicious messages
- **Privacy-First** - All processing happens on-device, no data sent to external servers
- **Educational Content** - Daily security tips to help users stay safe

## How It Works

TextBuddy uses the [pirocheto/phishing-url-detection](https://huggingface.co/pirocheto/phishing-url-detection) model to analyze URLs in incoming SMS messages. When a message arrives:

1. The Message Filter Extension extracts all URLs from the message
2. Each URL is analyzed by the ONNX model
3. If any URL has a phishing probability > 50%, the message is marked as junk

## Setup

### Enable SMS Filtering

1. Open **Settings** app
2. Go to **Messages** → **Unknown & Spam**
3. Enable **SMS Filtering**
4. Select **TextBuddy**

### Build Requirements

- Xcode 15+
- iOS 17+
- Swift 5.9+

### Dependencies

- [ONNX Runtime](https://github.com/microsoft/onnxruntime-swift-package-manager) - ML inference engine

## Project Structure

```
SMS Protection/
├── SMS Protection/          # Main app target
│   ├── ContentView.swift    # Main UI
│   ├── LearnView.swift      # Educational content
│   ├── ONNXInference.swift  # ML model wrapper
│   └── SecurityTips.swift   # Daily tips
├── SMS Protection Filter/   # Message Filter Extension
│   └── MessageFilterExtension.swift
└── model.onnx               # Phishing detection model (23MB)
```

## Testing

Run unit tests to verify the model correctly identifies phishing URLs:

```bash
xcodebuild test -scheme "SMS Protection" -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

## Model Performance

The model correctly distinguishes between:
- Phishing URLs (e.g., `secure-paypal-login.suspicious-site.com`) → Detected
- Legitimate URLs (e.g., `google.com`, `nytimes.com`) → Not flagged

## License

MIT
