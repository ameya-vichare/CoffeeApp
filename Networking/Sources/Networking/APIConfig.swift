//
//  APIConfig.swift
//  Networking
//
//  Created by Ameya on 07/09/25.
//

import Foundation

public protocol APIConfig {
    func path() -> String
    func queryItems() -> [URLQueryItem]?
    func httpMethod() -> HTTPMethod
    func httpBody() -> Data?
    func httpHeaders() -> [String: String]?
}
