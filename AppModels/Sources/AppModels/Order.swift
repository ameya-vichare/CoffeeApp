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
    public let items: [OrderItem]
    
    enum CodingKeys: String, CodingKey {
        case id = "order_id"
        case createdAt = "created_at"
        case totalPrice = "total_price"
        case currency
        case userName = "user_name"
        case items
    }
    
    public init(
        id: String?,
        createdAt: String?,
        userName: String?,
        currency: String?,
        totalPrice: String?,
        items: [OrderItem]
    ) {
        self.id = id
        self.createdAt = createdAt
        self.totalPrice = totalPrice
        self.currency = currency
        self.userName = userName
        self.items = items
    }
}

public struct OrderItem: Decodable {
    public let name: String?
    public let imageURL: String?
    public let size: String?
    public let quantity: String?
    public let totalPrice: String?
    public let currency: String?
    public let modifier: [Modifier]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageURL = "image_url"
        case size
        case quantity
        case totalPrice = "total_price"
        case currency
        case modifier
    }
    
    public init(name: String?, imageURL: String?, size: String?, quantity: String?, totalPrice: String?, currency: String?, modifier: [Modifier]?) {
        self.name = name
        self.imageURL = imageURL
        self.size = size
        self.quantity = quantity
        self.totalPrice = totalPrice
        self.currency = currency
        self.modifier = modifier
    }
}

public struct Modifier: Decodable {
    public let group: String?
    public let name: String?
    
    public init(group: String?, name: String?) {
        self.group = group
        self.name = name
    }
}
