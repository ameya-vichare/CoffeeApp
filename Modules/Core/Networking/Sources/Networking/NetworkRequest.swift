//
//  NetworkRequest.swift
//  Networking
//
//  Created by Ameya on 06/09/25.
//

import Foundation

public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

public struct NetworkRequest {
    public let path: String
    public let httpMethod: HTTPMethod
    public let httpBody: Data?
    public let queryItems: [URLQueryItem]?
    public let httpHeaders: [String: String]?
    
    public init(
        apiConfig: APIConfig
    ) {
        self.path = apiConfig.path()
        self.httpMethod = apiConfig.httpMethod()
        self.httpBody = apiConfig.httpBody()
        self.queryItems = apiConfig.queryItems()
        self.httpHeaders = apiConfig.httpHeaders()
    }
}
