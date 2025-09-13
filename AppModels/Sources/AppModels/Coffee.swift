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
    
    enum CodingKeys: String, CodingKey {
        case id
        case userName = "user_name"
        case type = "coffee_type"
        case size
        case extras
        case status
    }
    
    public init(id: Int?, userName: String?, type: CoffeeType?, size: CoffeeSize?, extras: String?, status: OrderStatus?) {
        self.id = id
        self.userName = userName
        self.type = type
        self.size = size
        self.extras = extras
        self.status = status
    }
}

public enum CoffeeType: String, Decodable {
    case cappuccino = "Cappuccino"
    case latte = "Latte"
    case mocha = "Mocha"
    case flatWhite = "Flat White"
}

public enum CoffeeSize: String, Decodable {
    case large = "L"
    case medium = "M"
    case small = "S"
}

public enum OrderStatus: String, Decodable {
    case preparing
    case ready
}
