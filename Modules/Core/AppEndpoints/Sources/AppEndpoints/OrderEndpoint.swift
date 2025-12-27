//
//  CoffeeEndpoint.swift
//  AppEndpoints
//
//  Created by Ameya on 13/09/25.
//

import Networking
import Foundation

public enum OrderEndpoint: APIConfig {
    case getOrders(cursor: String?)
    case sendOrder
    
    public func path() -> String {
        switch self {
        case .getOrders(_):
            "/ongoing-orders"
        case .sendOrder:
            "/coffees"
        }
    }
    
    public func httpMethod() -> Networking.HTTPMethod {
        switch self {
        case .getOrders(_):
            .GET
        case .sendOrder:
            .POST
        }
    }
    
    public func httpBody() -> Data? {
        nil
    }
    
    public func httpHeaders() -> [String : String]? {
        switch self {
        case .getOrders(_):
            return nil
        case .sendOrder:
            return ["Content-Type": "application/json"]
        }
    }
    
    public func queryItems() -> [URLQueryItem]? {
        switch self {
        case .getOrders(let cursor):
            return [
                URLQueryItem(name: "cursor", value: cursor ?? "")
            ]
        case .sendOrder:
            return nil
        }
    }
}
