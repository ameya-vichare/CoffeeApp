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
    case decodingError(errorDescription: String)
    case cancelled
    case urlError(errorDescription: String)
    case requestFailed(errorDescription: String)
    case noInternet
    
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
    
    var statusCode: Int? {
        switch self {
        case .invalidResponse(let statusCode, _):
            return statusCode
        default:
            return nil
        }
    }
    
    public var title: String {
        switch self {
        case .noInternet:
            "No Internet Connection."
        default:
            "Something went wrong."
        }
    }
    
    public var message: String {
        switch self {
        case .noInternet:
            "Please check your internet connection and try again."
        default:
            "Please try again in sometime."
        }
    }
}
