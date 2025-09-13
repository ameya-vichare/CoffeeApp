//
//  NetworkClient.swift
//  Networking
//
//  Created by Ameya on 06/09/25.
//

import Foundation
import Combine

public protocol NetworkService {
    func perform<T: Decodable>(request: NetworkRequest, response: T.Type) -> AnyPublisher<T, NetworkError>
}

public class NetworkClient: NetworkService {
    let baseURL: URL
    let session: URLSession
    let decoder: JSONDecoder
    let defaultHeaders: [String: String]
    
    public init(
        baseURL: URL,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        defaultHeaders: [String: String] = ["Content-Type": "application/json"]
    ) {
        self.baseURL = baseURL
        self.session = session
        self.defaultHeaders = defaultHeaders
        self.decoder = decoder
    }
    
    
    public func perform<T: Decodable>(request: NetworkRequest, response: T.Type) -> AnyPublisher<T, NetworkError> {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(request.path), resolvingAgainstBaseURL: false) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        components.queryItems = request.queryItems

        guard let url = components.url else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.httpBody = request.httpBody
        
        var finalHeaders = defaultHeaders
        if let requestHeaders = request.httpHeaders {
            finalHeaders.merge(requestHeaders) { _, new in new }
        }
        
        for (key, value) in finalHeaders {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        let publisher = session
            .dataTaskPublisher(for: urlRequest)
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse(statusCode: -1, data: output.data)
                }
                
                guard (200...299).contains(response.statusCode) else {
                    throw NetworkError.invalidResponse(statusCode: response.statusCode, data: output.data)
                }
                return output.data
            }
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .decode(type: T.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .mapError { error in
                if let error = error as? NetworkError {
                    return error
                }
                else if let error = error as? URLError,
                            error.code == .cancelled {
                    return NetworkError.cancelled
                }
                else if let error = error as? DecodingError {
                    return NetworkError.decodingError(error: error)
                }
                return NetworkError.requestFailed(error: error)
            }
            .eraseToAnyPublisher()
        
        return publisher
    }
}
