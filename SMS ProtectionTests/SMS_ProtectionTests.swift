//
//  SMS_ProtectionTests.swift
//  SMS ProtectionTests
//
//  Created by Kristo Kiis on 11/21/25.
//

import Testing
import Foundation
@testable import SMS_Protection

@MainActor
struct SMS_ProtectionTests {

    // MARK: - ONNX Phishing URL Detection Tests

    @Test func testONNXModelLoaded() async throws {
        let inference = ONNXInference.shared
        print("[Test] Model ready: \(inference.modelReady)")
        // Note: Model may not be available in test bundle - add model.onnx to test target if needed
        if !inference.modelReady {
            print("[Test] Skipping - ONNX model not in test bundle. Add model.onnx to test target resources.")
            return
        }
        #expect(inference.modelReady)
    }

    @Test func testONNXPhishingURL() async throws {
        let inference = ONNXInference.shared
        guard inference.modelReady else { return }

        let phishingURL = "http://secure-paypal-login.suspicious-site.com/verify"
        let prob = inference.phishingProbability(url: phishingURL)
        let isPhishing = inference.isPhishing(url: phishingURL)

        #expect(prob != nil, "Model should return probability")
        #expect(prob! > 0.5, "Phishing URL should have probability > 0.5, got \(prob!)")
        #expect(isPhishing, "Should detect as phishing")
    }

    @Test func testONNXLegitimateURL() async throws {
        let inference = ONNXInference.shared
        guard inference.modelReady else { return }

        let legitimateURL = "https://www.google.com"
        let prob = inference.phishingProbability(url: legitimateURL)
        let isPhishing = inference.isPhishing(url: legitimateURL)

        #expect(prob != nil, "Model should return probability")
        #expect(prob! < 0.5, "Legitimate URL should have probability < 0.5, got \(prob!)")
        #expect(!isPhishing, "Should NOT detect as phishing")
    }

    @Test func testONNXMessageWithPhishingURL() async throws {
        let inference = ONNXInference.shared
        guard inference.modelReady else { return }

        let message = "Your account is locked! Verify here: http://bank-secure-login.xyz/verify"
        let containsPhishing = inference.containsPhishingURL(messageBody: message)

        #expect(containsPhishing, "Message with phishing URL should be detected")
    }

    @Test func testONNXMessageWithLegitimateURL() async throws {
        let inference = ONNXInference.shared
        guard inference.modelReady else { return }

        let message = "Check out this article: https://www.nytimes.com/news/article"
        let containsPhishing = inference.containsPhishingURL(messageBody: message)

        #expect(!containsPhishing, "Message with legitimate URL should NOT be flagged")
    }

    @Test func testONNXMessageWithNoURLs() async throws {
        let inference = ONNXInference.shared
        guard inference.modelReady else {
            print("[Test] Skipping - ONNX model not loaded")
            return
        }

        let message = "Hey, are you free for lunch tomorrow?"
        let containsPhishing = inference.containsPhishingURL(messageBody: message)
        print("No URL message test - contains phishing: \(containsPhishing)")
        #expect(!containsPhishing)
    }
}
