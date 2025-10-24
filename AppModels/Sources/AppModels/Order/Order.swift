//
//  Coffee.swift
//  AppModels
//
//  Created by Ameya on 13/09/25.
//

public struct Order: Decodable {
    public let id: String?
    public let createdAt: String?
    public let totalPrice: String?
    public let currency: String?
    public let userName: String?
    public let status: OrderStatus?
    public let items: [OrderItem]
    
    enum CodingKeys: String, CodingKey {
        case id = "order_id"
        case createdAt = "created_at"
        case totalPrice = "total_price"
        case currency
        case userName = "user_name"
        case status
        case items
    }
    
    public init(
        id: String?,
        createdAt: String?,
        userName: String?,
        currency: String?,
        totalPrice: String?,
        status: OrderStatus?,
        items: [OrderItem]
    ) {
        self.id = id
        self.createdAt = createdAt
        self.totalPrice = totalPrice
        self.currency = currency
        self.userName = userName
        self.status = status
        self.items = items
    }
}






