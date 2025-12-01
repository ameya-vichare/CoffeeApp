//
//  CreateOrderEndpoint.swift
//  AppEndpoints
//
//  Created by Ameya on 02/11/25.
//

import Networking
import AppModels
import Foundation

public enum CreateOrderEndpoint: APIConfig {
    case createOrder(data: CreateOrder)
    
    public func path() -> String {
        "/create-order"
    }

    public func queryItems() -> [URLQueryItem]? {
        nil
    }

    public func httpMethod() -> Networking.HTTPMethod {
        .POST
    }

    public func httpBody() -> Data? {
        switch self {
        case .createOrder(let data):
            return try? JSONEncoder().encode(data)
        }
    }

    public func httpHeaders() -> [String : String]? {
        ["Content-Type": "application/json"]
    }
}
