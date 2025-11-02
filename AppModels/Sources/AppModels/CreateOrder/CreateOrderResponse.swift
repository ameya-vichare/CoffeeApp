//
//  CreateOrderResponse.swift
//  AppModels
//
//  Created by Ameya on 02/11/25.
//

import Foundation

public struct CreateOrderResponse: Decodable {
    let orderId: String
    
    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
    }
    
    public static func createFake() -> CreateOrderResponse {
        CreateOrderResponse(orderId: "1234567890")
    }
}
