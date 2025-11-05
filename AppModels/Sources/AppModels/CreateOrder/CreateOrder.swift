//
//  CreateOrder.swift
//  AppModels
//
//  Created by Ameya on 02/11/25.
//

public struct CreateOrder: Codable {
    public let userId: Int
    public let items: [CreateOrderItem]
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case items
    }
    
    public init(userId: Int, items: [CreateOrderItem] = []) {
        self.userId = userId
        self.items = items
    }
}
