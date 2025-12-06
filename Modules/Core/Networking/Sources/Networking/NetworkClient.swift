//
//  NetworkClient.swift
//  Networking
//
//  Created by Ameya on 06/09/25.
//

import Foundation

public protocol NetworkService: Sendable {
    func set(headerProvider: NetworkServiceHeaderProvider?)
    
    func perform<T: Decodable>(request: NetworkRequest, responseType: T.Type) async throws -> T
    func performRaw(request: NetworkRequest) async throws -> NetworkResponse
}

public protocol NetworkServiceHeaderProvider: AnyObject {
    func getDynamicHeaders() -> [String: String]
}

public final class NetworkClient: NetworkService {
    let baseURL: URL?
    let session: URLSessionProtocol
    let decoder: JSONDecoder
    let defaultHeaders: [String: String]
    weak var headerProvider: NetworkServiceHeaderProvider?
    
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
    
    public func set(headerProvider: NetworkServiceHeaderProvider?) {
        self.headerProvider = headerProvider
    }
    
    public func perform<T: Decodable & Sendable>(request: NetworkRequest, responseType: T.Type) async throws -> T {
        let urlRequest: URLRequest = try buildURLRequest(request: request)
        let (data, response): (Data, URLResponse) = try await performAPICall(with: urlRequest)
        let _ = try handleURLResponse(response: response, data: data)
        let parsedData: T = try await parseData(data: data, decoder: self.decoder)
        
        return parsedData
    }
    
    public func performRaw(request: NetworkRequest) async throws -> NetworkResponse {
        let urlRequest: URLRequest = try buildURLRequest(request: request)
        let (data, response): (Data, URLResponse) = try await performAPICall(with: urlRequest)
        let httpURLResponse: HTTPURLResponse = try handleURLResponse(response: response, data: data)
        
        return NetworkResponse(data: data, response: httpURLResponse)
    }
    
    // TODO: Network call cancellation
    
    // TODO: Network retries with backoff
    
    // TODO: Network timeout
    
    // TODO: Offline error
    
    // TODO: Custom error handling
}

extension NetworkClient {
    func buildURLRequest(request: NetworkRequest) throws -> URLRequest {
        guard let baseURL,
              var components = URLComponents(
                url: baseURL.appendingPathComponent(request.path),
                resolvingAgainstBaseURL: false
              )
        else {
            throw NetworkError.invalidURL
        }
        
        components.queryItems = request.queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.httpBody = request.httpBody
        
        var finalHeaders = defaultHeaders
        
        if let dynamicHeaders = self.headerProvider?.getDynamicHeaders() {
            finalHeaders.merge(dynamicHeaders) { _, new in new }
        }
        
        if let requestHeaders = request.httpHeaders {
            finalHeaders.merge(requestHeaders) { _, new in new }
        }
        
        for (key, value) in finalHeaders {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
    
    private func performAPICall(with urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await self.session.data(for: urlRequest, delegate: nil)
        } catch let error as URLError where error.code == .cancelled {
            throw NetworkError.cancelled
        } catch {
            throw NetworkError.requestFailed(errorDescription: error.localizedDescription)
        }
    }
    
    @discardableResult
    private func handleURLResponse(response: URLResponse, data: Data) throws -> HTTPURLResponse {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(statusCode: -1, data: data)
        }
        
        guard (200...299).contains(response.statusCode) else {
            throw NetworkError.invalidResponse(statusCode: response.statusCode, data: data)
        }
        
        return response
    }
    
    private func parseData<T: Decodable & Sendable>(data: Data, decoder: JSONDecoder) async throws -> T {
        return try await Task.detached(priority: .background) {
            do {
                return try decoder.decode(T.self, from: data)
            } catch let error as DecodingError {
                throw NetworkError.decodingError(errorDescription: error.localizedDescription)
            } catch {
                throw NetworkError.requestFailed(errorDescription: error.localizedDescription)
            }
        }.value
    }
}
