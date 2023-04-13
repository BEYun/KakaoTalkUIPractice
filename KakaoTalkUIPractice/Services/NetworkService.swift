//
//  ChatGPTViewModel.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/04/05.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestError
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case decodingError
    case emptyData
    case unknownError
}

// completionHandler의 반환 타입을 제네릭으로 표현
protocol APINetworkService {
    typealias completionHandler<T> = (Result<T, NetworkError>) -> Void
    
    func networkRequest<T: Decodable>(request: URLRequest, completion: @escaping completionHandler<T>)
}

final class NetworkService {
    private weak var task: URLSessionTask?
    
    private func getError(statusCode: Int) -> NetworkError? {
        switch statusCode {
        case 200...299: return nil
        case 400...499: return .clientError(statusCode: statusCode)
        case 500...599: return .serverError(statusCode: statusCode)
        default: return .unknownError
        }
    }
    
    // Error Check의 반환타입으로 Result 타입 반환
    private func checkError(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        // Request 실패 에러
        if error != nil {
            completion(.failure(NetworkError.requestError))
            return
        }
        // Response nil 에러
        guard let response = response as? HTTPURLResponse else {
            completion(.failure(NetworkError.unknownError))
            return
        }
        // statusCode에 따른 에러
        if let responseError = getError(statusCode: response.statusCode) {
            completion(.failure(responseError))
            return
        }
        // 데이터 유실 에러
        guard let data = data else {
            completion(.failure(NetworkError.emptyData))
            return
        }
        
        completion(.success((data)))
    }
    
    // Error Check로 반환된 값을 디코딩하여 다시 제네릭하게 반환
    private func decode<T: Decodable>(data: Data) -> Result<T, NetworkError> {
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(NetworkError.decodingError)
        }
    }
    
    deinit {
        print("NetworkService Deinit")
        task?.cancel()
    }
}

extension NetworkService: APINetworkService {
    // 1. Request 요청에 따른 task에 대해 에러를 체크
    // 2. result에 따라 completion에 .success -> decoding 작업 수행, .failure -> error 반환 작업 수행
    // 3. NetworkService 클래스를 프로퍼티로 가지는 클래스(예, ChatGPTNetworkRepository)에서 제네릭 타입 선언 가능
    func networkRequest<T: Decodable>(request: URLRequest, completion: @escaping completionHandler<T>) {
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            self?.checkError(data: data, response: response, error: error, completion: { result in
                switch result {
                case .success(let data):
                    guard let self = self else { return }
                    completion(self.decode(data: data))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
        task.resume()
        self.task = task
    }

}
