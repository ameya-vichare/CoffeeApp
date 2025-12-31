//
//  CoffeeEndpoint.swift
//  AppEndpoints
//
//  Created by Ameya on 13/09/25.
//

import Networking
import Foundation
import AppModels

public enum OrderEndpoint: APIConfig {
    case getOrders(cursor: String?)
    case createOrder(data: CreateOrder)
    
    public func path() -> String {
        switch self {
        case .getOrders(_):
            "/ongoing-orders"
        case .createOrder(_):
            "/create-order"
        }
    }
    
    public func httpMethod() -> Networking.HTTPMethod {
        switch self {
        case .getOrders(_):
            .GET
        case .createOrder(_):
            .POST
        }
    }
    
    public func httpBody() -> Data? {
        switch self {
        case .getOrders(_):
            return nil
        case .createOrder(let data):
            return try? JSONEncoder().encode(data)
        }
    }
    
    public func httpHeaders() -> [String : String]? {
        switch self {
        case .getOrders(_):
            return nil
        case .createOrder(let data):
            return ["Content-Type": "application/json"]
        }
    }
    
    public func queryItems() -> [URLQueryItem]? {
        switch self {
        case .getOrders(let cursor):
            return [
                URLQueryItem(name: "cursor", value: cursor ?? "")
            ]
        case .createOrder(_):
            return nil
        }
    }
}
