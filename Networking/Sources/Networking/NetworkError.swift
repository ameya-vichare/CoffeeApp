//
//  NetworkError.swift
//  Networking
//
//  Created by Ameya on 06/09/25.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse(statusCode: Int, data: Data?)
    case decodingError(error: Error)
    case cancelled
    case requestFailed(error: Error)
}
