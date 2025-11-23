//
//  ONNXInference.swift
//  SMS Protection
//
//  Created by Kristo Kiis on 11/21/25.
//

import Foundation
import OnnxRuntimeBindings

class ONNXInference {
    static let shared = ONNXInference()

    private var session: ORTSession?
    private var env: ORTEnv?
    private var isReady = false

    private init() {
        loadModel()
    }

    private func loadModel() {
        do {
            // Initialize ONNX Runtime environment
            env = try ORTEnv(loggingLevel: .warning)

            // Find model in bundle - try multiple bundles for test compatibility
            var modelPath: String?
            for bundle in Bundle.allBundles {
                if let path = bundle.path(forResource: "model", ofType: "onnx") {
                    modelPath = path
                    break
                }
            }

            guard let modelPath = modelPath else {
                print("[ONNX] Model not found in any bundle")
                return
            }

            // Create session options
            let sessionOptions = try ORTSessionOptions()
            try sessionOptions.setGraphOptimizationLevel(.all)

            // Create inference session
            session = try ORTSession(env: env!, modelPath: modelPath, sessionOptions: sessionOptions)
            isReady = true

            print("[ONNX] Model loaded successfully")

        } catch {
            print("[ONNX] Failed to load model: \(error)")
        }
    }

    /// Check if model is ready for inference
    var modelReady: Bool {
        return isReady && session != nil
    }

    /// Run inference on a text message
    /// - Parameter text: The SMS message text
    /// - Returns: Tuple of (isSpam: Bool, probability: Float), or nil if inference fails
    func predict(text: String) -> (isSpam: Bool, probability: Float)? {
        guard let session = session else {
            print("[ONNX] Session not initialized")
            return nil
        }

        do {
            // Create string input tensor
            let inputTensor = try ORTValue(tensorStringData: [text], shape: [1])

            // Run inference
            let outputs = try session.run(
                withInputs: ["inputs": inputTensor],
                outputNames: ["label", "probabilities"],
                runOptions: nil
            )

            // Extract label (0 = ham, 1 = spam)
            guard let labelTensor = outputs["label"] else {
                print("[ONNX] No label output")
                return nil
            }

            let labelData = try labelTensor.tensorData() as Data
            let label = labelData.withUnsafeBytes { $0.load(as: Int64.self) }

            // Extract probabilities
            var probability: Float = 0.0
            if let probTensor = outputs["probabilities"] {
                let probData = try probTensor.tensorData() as Data
                let probs = probData.withUnsafeBytes { pointer in
                    Array(pointer.bindMemory(to: Float.self))
                }
                if probs.count >= 2 {
                    probability = probs[1]  // Probability of spam (class 1)
                }
            }

            let isSpam = label == 1
            print("[ONNX] Prediction: \(isSpam ? "SPAM" : "HAM") (prob: \(probability))")

            return (isSpam: isSpam, probability: probability)

        } catch {
            print("[ONNX] Inference error: \(error)")
            return nil
        }
    }

    /// Check if a URL is phishing
    /// - Parameter url: The URL string to check
    /// - Returns: True if phishing, false otherwise
    func isPhishing(url: String) -> Bool {
        return predict(text: url)?.isSpam ?? false
    }

    /// Check if a URL is phishing
    /// - Parameter url: The URL to check
    /// - Returns: True if phishing, false otherwise
    func isPhishing(url: URL) -> Bool {
        return isPhishing(url: url.absoluteString)
    }

    /// Get phishing probability for a URL
    /// - Parameter url: The URL string to check
    /// - Returns: Probability 0.0-1.0, or nil if inference fails
    func phishingProbability(url: String) -> Float? {
        return predict(text: url)?.probability
    }

    /// Check message for phishing URLs
    /// - Parameter messageBody: The SMS message text
    /// - Returns: True if any URL in the message is phishing
    func containsPhishingURL(messageBody: String) -> Bool {
        let urls = extractURLs(from: messageBody)
        for url in urls {
            if isPhishing(url: url) {
                return true
            }
        }
        return false
    }

    /// Extracts all URLs from text
    private func extractURLs(from text: String) -> [URL] {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return []
        }
        let matches = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        return matches.compactMap { match in
            guard let range = Range(match.range, in: text),
                  let url = URL(string: String(text[range])) else {
                return nil
            }
            return url
        }
    }
}
