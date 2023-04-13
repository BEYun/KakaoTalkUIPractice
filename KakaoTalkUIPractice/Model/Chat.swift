//
//  Chat.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/04/05.
//

import Foundation

struct Chat: Codable {
    let role: String
    let content: String
    
    init(role: String, content: String) {
        self.role = role
        self.content = content
    }
}


struct ChatCollection: Codable {
    let model: String
    let messages: [Chat]
    let max_tokens: Int?
    
    init(messages: [Chat]) {
        self.model = "gpt-3.5-turbo"
        self.messages = messages
        self.max_tokens = 200
    }
}
