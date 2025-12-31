//
//  LogoutEndpoint.swift
//  AppEndpoints
//
//  Created by Ameya on 31/12/25.
//

import Networking
import AppModels
import Foundation

public enum LogoutEndpoint: APIConfig {
    case logout
    
    public func path() -> String {
        "/logout"
    }

    public func queryItems() -> [URLQueryItem]? {
        nil
    }

    public func httpMethod() -> Networking.HTTPMethod {
        .POST
    }

    public func httpBody() -> Data? {
        nil
    }

    public func httpHeaders() -> [String : String]? {
        nil
    }
}
