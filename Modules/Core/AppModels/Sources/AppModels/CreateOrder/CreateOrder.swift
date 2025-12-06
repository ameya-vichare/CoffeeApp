//
//  CreateOrder.swift
//  AppModels
//
//  Created by Ameya on 02/11/25.
//

public struct CreateOrder: Codable {
    public let items: [CreateOrderItem]
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    
    public init(items: [CreateOrderItem]) {
        self.items = items
    }
}
