//
//  ChatGPTNetworkRepository+DTO.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/04/13.
//

import Foundation

// MARK: ChatResponseDTO
struct ChatResponseDTO: Codable {
    let id: String
    let object: String
    let created: Int
    let choices: [Choice]
    let usage: Usage
}

// MARK: Choice
struct Choice: Codable {
    let index: Int
    let message: Message
    let finishReason: String

    enum CodingKeys: String, CodingKey {
        case index, message
        case finishReason = "finish_reason"
    }
}

// MARK: Message
struct Message: Codable {
    let role: String
    let content: String
}

// MARK: Usage
struct Usage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

// MARK: - ChatRequestDTO
struct ChatRequestDTO: Codable {
    let model: String = "gpt-3.5-turbo"
    let messages: [Message]
    let maxTokens: Int = 200
    
    enum CodingKeys: String, CodingKey {
        case model, messages
        case maxTokens = "max_tokens"
    }
}



