//
//  Coffee.swift
//  AppModels
//
//  Created by Ameya on 13/09/25.
//

public struct Coffee: Decodable {
    public let id: Int?
    public let userName: String?
    public let type: CoffeeType?
    public let size: CoffeeSize?
    public let extras: String?
    public let status: OrderStatus?
    public let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userName = "user_name"
        case type = "coffee_type"
        case size
        case extras
        case status
        case createdAt = "created_at"
    }
    
    public init(id: Int?, userName: String?, type: CoffeeType?, size: CoffeeSize?, extras: String?, status: OrderStatus?, createdAt: String?) {
        self.id = id
        self.userName = userName
        self.type = type
        self.size = size
        self.extras = extras
        self.status = status
        self.createdAt = createdAt
    }
}

public enum CoffeeType: String, Decodable {
    case cappuccino = "Cappuccino"
    case latte = "Latte"
    case mocha = "Mocha"
    case flatWhite = "Flat White"
    
    public var imageURL: String {
        switch self {
        case .cappuccino:
            "https://www.acouplecooks.com/wp-content/uploads/2020/10/how-to-make-cappuccino-005.jpg"
        case .latte:
            "https://images.unsplash.com/photo-1630021439100-74a32ab42d3e?q=80&w=1424&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
        case .mocha:
            "https://images.unsplash.com/photo-1600056781444-55f3b64235e3?q=80&w=1064&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
        case .flatWhite:
            "https://images.unsplash.com/photo-1640506786175-8c754525644a?q=80&w=1420&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
        }
    }
}

public enum CoffeeSize: String, Decodable {
    case large = "L"
    case medium = "M"
    case small = "S"
    
    public var description: String {
        switch self {
        case .large:
            "Large"
        case .medium:
            "Medium"
        case .small:
            "Small"
        }
    }
}

public enum OrderStatus: String, Decodable {
    case preparing
    case ready
}
