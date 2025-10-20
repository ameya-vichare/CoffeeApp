//
//  NetworkError.swift
//  Networking
//
//  Created by Ameya on 06/09/25.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse(statusCode: Int, data: Data?)
    case unableToDecode
    case decodingError(error: Error)
    case cancelled
    case requestFailed(error: Error)
    
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}
