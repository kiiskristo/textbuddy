//
//  MessageFilterExtension.swift
//  SMS Protection Filter
//
//  Created by Kristo Kiis on 11/21/25.
//

import IdentityLookup

final class MessageFilterExtension: ILMessageFilterExtension {
    // Lazy load ONNX phishing URL detection model
    private lazy var onnxInference = ONNXInference.shared
}

extension MessageFilterExtension: ILMessageFilterQueryHandling {

    func handle(_ queryRequest: ILMessageFilterQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterQueryResponse) -> Void) {
        let messageBody = queryRequest.messageBody ?? ""

        // Use AI model for phishing URL detection
        let isSuspicious = onnxInference.modelReady && onnxInference.containsPhishingURL(messageBody: messageBody)

        let response = ILMessageFilterQueryResponse()
        response.action = isSuspicious ? .junk : .allow

        completion(response)
    }
}
