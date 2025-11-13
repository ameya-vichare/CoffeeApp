//
//  OrderItem.swift
//  AppModels
//
//  Created by Ameya on 24/10/25.
//


public struct OrderItem: Decodable {
    public let name: String?
    public let imageURL: String?
    public let quantity: String?
    public let totalPrice: String?
    public let currency: String?
    public let modifier: [OrderModifier]
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageURL = "image_url"
        case quantity
        case totalPrice = "total_price"
        case currency
        case modifier
    }
    
    public init(name: String?, imageURL: String?, size: String?, quantity: String?, totalPrice: String?, currency: String?, modifier: [OrderModifier]) {
        self.name = name
        self.imageURL = imageURL
        self.quantity = quantity
        self.totalPrice = totalPrice
        self.currency = currency
        self.modifier = modifier
    }
    
    public static func createFake() -> OrderItem {
        OrderItem(
            name: "Hot Orange Zest Mocha",
            imageURL: "https://via.placeholder.com/150",
            size: "Medium",
            quantity: "1",
            totalPrice: "12",
            currency: "USD",
            modifier: [
                OrderModifier(
                    group: "Size",
                    name: "Small"
                ),
                OrderModifier(
                    group: "Syrup",
                    name: "Caramel"
                )
            ]
        )
    }
}
