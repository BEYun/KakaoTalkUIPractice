//
//  ChatGPTNetworkRepository.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/04/11.
//

import Foundation

protocol ChatGPTResultType {
    typealias ResultType = Result<ChatResponseDTO, NetworkError>
}

class ChatGPTNetworkRepository {
    private let networkService: NetworkService
    
    private let openAPIKey = Bundle.main.apiKey
    
    private var historyMessage: [Message] = []
    private var currentMessage: Message? {
        didSet {
            if let currentChat = currentMessage {
                historyMessage.append(currentChat)
            }
        }
    }
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func makeRequest() throws -> URLRequest {
        let baseURLString = "https://api.openai.com"
        let endpoint = "/v1/chat/completions"
        guard let url = URL(string: baseURLString + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(openAPIKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if !historyMessage.isEmpty {
            let chatRequestDTO = ChatRequestDTO(messages: historyMessage)
            request.httpBody = try? JSONEncoder().encode(chatRequestDTO)
        }
        
        return request
    }
}

extension ChatGPTNetworkRepository: ChatGPTResultType {
    func fetchData(query: String, completion: @escaping (ResultType) -> Void) {
        currentMessage = Message(role: "user", content: query)
        do {
            let request = try makeRequest()
            self.networkService.networkRequest(request: request) { result in
                // networkRequest의 completionHandler의 제네릭 타입을 Result<Data, NetworkError>로 명시
                let result = result as ResultType
                switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(NetworkError.invalidURL))
        }
    }
}
