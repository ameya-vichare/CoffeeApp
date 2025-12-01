//
//  MenuEndpoint.swift
//  AppEndpoints
//
//  Created by Ameya on 24/10/25.
//

import Networking
import Foundation

public enum MenuEndpoint: APIConfig {
    case getMenuItems
    
    public func path() -> String {
        "/order-menu"
    }

    public func queryItems() -> [URLQueryItem]? {
        nil
    }

    public func httpMethod() -> Networking.HTTPMethod {
        .GET
    }

    public func httpBody() -> Data? {
        nil
    }

    public func httpHeaders() -> [String : String]? {
        nil
    }
}
