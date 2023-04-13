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
    // 현재 대화 내용을 모두 가지고 있는 Message 배열
    private var historyMessage: [Message] = []
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func makeRequest() throws -> URLRequest {
        let endpoint = try ChatGPTEndPoint.completions.url
        
        var request = URLRequest(url: endpoint)
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
        let currentMessage = Message(role: "user", content: query)
        historyMessage.append(currentMessage)
        
        do {
            let request = try makeRequest()
            
            self.networkService.networkRequest(request: request) { result in
                // networkRequest의 completionHandler의 제네릭 타입을 Result<ChatResponseDTO, NetworkError>로 타입 캐스팅
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
