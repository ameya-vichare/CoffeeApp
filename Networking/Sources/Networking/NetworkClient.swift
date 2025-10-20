//
//  NetworkClient.swift
//  Networking
//
//  Created by Ameya on 06/09/25.
//

import Foundation

public protocol NetworkService {
    func perform<T: Decodable>(request: NetworkRequest, response: T.Type) async throws -> T
}

public class NetworkClient: NetworkService {
    let baseURL: URL?
    let session: URLSessionProtocol
    let decoder: JSONDecoder
    let defaultHeaders: [String: String]
    
    public init(
        baseURL: URL?,
        session: URLSessionProtocol = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder(),
        defaultHeaders: [String: String] = [:]
    ) {
        self.baseURL = baseURL
        self.session = session
        self.defaultHeaders = defaultHeaders
        self.decoder = decoder
    }
    
    public func perform<T: Decodable & Sendable>(request: NetworkRequest, response: T.Type) async throws -> T {
        guard let baseURL,
              var components = URLComponents(
                url: baseURL.appendingPathComponent(request.path),
                resolvingAgainstBaseURL: false
              )
        else {
            throw NetworkError.invalidURL
        }
        
        components.queryItems = request.queryItems

        var urlRequest = URLRequest(url: baseURL)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.httpBody = request.httpBody
        
        var finalHeaders = defaultHeaders
        if let requestHeaders = request.httpHeaders {
            finalHeaders.merge(requestHeaders) { _, new in new }
        }
        
        for (key, value) in finalHeaders {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        var (data, response): (Data?, URLResponse?)
        
        do {
            (data, response) = try await self.session.data(for: urlRequest, delegate: nil)
        } catch let error as URLError {
            if error.code == .cancelled {
                throw NetworkError.cancelled
            }
        } catch {
            throw NetworkError.requestFailed(errorDescription: error.localizedDescription)
        }
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(statusCode: -1, data: data)
        }
        
        guard (200...299).contains(response.statusCode) else {
            throw NetworkError.invalidResponse(statusCode: response.statusCode, data: data)
        }
        
        guard let data else {
            throw NetworkError.unableToDecode
        }
        
        return try await Task.detached(priority: .background) {
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch let error as DecodingError {
                throw NetworkError.decodingError(errorDescription: error.localizedDescription)
            } catch {
                throw NetworkError.requestFailed(errorDescription: error.localizedDescription)
            }
        }.value
    }
}
