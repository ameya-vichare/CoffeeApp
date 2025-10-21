//
//  DummyGETAPIConfig.swift
//  Networking
//
//  Created by Ameya on 20/10/25.
//

import Foundation

final class DummyGETAPIConfig: APIConfig {
    func path() -> String {
        "/somePath"
    }
    
    func queryItems() -> [URLQueryItem]? {
        nil
    }
    
    func httpMethod() -> HTTPMethod {
        .GET
    }
    
    func httpBody() -> Data? {
        nil
    }
    
    func httpHeaders() -> [String : String]? {
        ["Content-Type": "application/json"]
    }
}
