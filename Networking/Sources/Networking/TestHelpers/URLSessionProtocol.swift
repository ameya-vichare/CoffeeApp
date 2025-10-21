//
//  URLSessionProtocol.swift
//  Networking
//
//  Created by Ameya on 20/10/25.
//

import Foundation

// Protocol for injecting a mock for URLSession
public protocol URLSessionProtocol {
    func data(for request: URLRequest, delegate: (URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
    
}
