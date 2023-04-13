//
//  ChatGPTEndPoint.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/04/13.
//

import Foundation

enum ChatGPTEndPoint {
    case completions
}

extension ChatGPTEndPoint {
    var url: URL {
        get throws {
            switch self {
            case .completions:
                return try URL.makeForEndpoint("/v1/chat/completions")
            }
        }
    }
}

private extension URL {
    static func makeForEndpoint(_ endpoint: String) throws -> URL {
        guard let url = URL(string: "https://api.openai.com\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        return url
    }
}
