//
//  ChatGPTViewModel.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/04/05.
//

import Foundation

class ChatGptAPI {
    private let openaiAPIKey: String
    private var currentChat: Chat? {
        didSet {
            if let currentChat = currentChat {
                historyChat.append(currentChat)
            }
        }
    }
    private var historyChat: [Chat] = []
    
    func makeRequest() -> URLRequest {
        let baseURLString = "https://api.openai.com"
        let endpoint = "/v1/chat/completions"
        let url = URL(string: baseURLString + endpoint)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(openaiAPIKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    func fetchMessage(to message: String, completion: @escaping (String?, Error?) -> Void) {
        var request = makeRequest()
        
        currentChat = Chat(content: message)
        let chatCollection = ChatCollection(messages: historyChat)

        let encoder = JSONEncoder()

        do {
            let body = try encoder.encode(chatCollection)
            request.httpBody = body
        } catch {
            completion(nil, error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            do {
                guard let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
                guard let choices = jsonResponse["choices"] as? [[String: Any]] else { return }
                let choice = choices[0]
                let message = choice["message"]
                guard let message = message as? [String: String] else { return }
                guard let role = message["role"] else { return }
                guard let content = message["content"] else { return }
                self.currentChat = Chat(role: role, content: content)
                
                completion(content, nil)
                
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    init(apiKey: String) {
        self.openaiAPIKey = apiKey
    }
    
    deinit {
        print("ChatGPT API Deinit")
    }

}
