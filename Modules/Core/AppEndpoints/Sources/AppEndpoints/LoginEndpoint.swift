//
//  LoginEndpoint.swift
//  AppEndpoints
//
//  Created by Ameya on 05/12/25.
//

import Networking
import AppModels
import Foundation

public enum LoginEndpoint: APIConfig {
    case login(data: UserLogin)
    
    public func path() -> String {
        "/login"
    }

    public func queryItems() -> [URLQueryItem]? {
        nil
    }

    public func httpMethod() -> Networking.HTTPMethod {
        .POST
    }

    public func httpBody() -> Data? {
        switch self {
        case .login(let data):
            return try? JSONEncoder().encode(data)
        }
    }

    public func httpHeaders() -> [String : String]? {
        ["Content-Type": "application/json"]
    }
}

