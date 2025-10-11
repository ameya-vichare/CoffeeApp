//
//  CoffeeEndpoint.swift
//  AppEndpoints
//
//  Created by Ameya on 13/09/25.
//

import Networking
import Foundation

public enum CoffeeOrderEndpoint: APIConfig {
    case getOrders
    case sendOrder
    
    public func path() -> String {
        switch self {
        case .getOrders:
            "/ongoing-orders"
        case .sendOrder:
            "/coffees"
        }
    }
    
    public func httpMethod() -> Networking.HTTPMethod {
        switch self {
        case .getOrders:
            .GET
        case .sendOrder:
            .POST
        }
    }
    
    public func httpBody() -> Data? {
        //TO DO
        nil
    }
    
    public func httpHeaders() -> [String : String]? {
        nil
//        ["Content-Type": "application/json"]
    }
    
    public func queryItems() -> [URLQueryItem]? {
        nil
    }
}
