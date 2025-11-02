//
//  Menu.swift
//  AppModels
//
//  Created by Ameya on 24/10/25.
//

import Foundation

public struct MenuItem: Decodable {
    public let id: Int?
    public let name: String?
    public let description: String?
    public let imageURL: String?
    public let basePrice: Double?
    public let currency: String?
    public let modifiers: [MenuModifier]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageURL = "image_url"
        case basePrice = "base_price"
        case currency = "currency"
        case modifiers = "modifier_groups"
    }
    
    public init(id: Int?, name: String?, description: String?, imageURL: String?, basePrice: Double?, currency: String?, modifiers: [MenuModifier]?) {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.basePrice = basePrice
        self.currency = currency
        self.modifiers = modifiers
    }
    
    public static func createFake() -> MenuItem {
        MenuItem(
            id: 8,
            name: "Hot Americano",
            description: "A shot of espresso, diluted to create a smooth black coffee.",
            imageURL: "https://images.unsplash.com/photo-1669872484166-e11b9638b50e",
            basePrice: 14.00,
            currency: "USD",
            modifiers: [
                MenuModifier(
                    id: 1,
                    name: "Milk Type",
                    selectionType: .single,
                    minSelect: 1,
                    maxSelect: 1,
                    options: [
                        MenuModifierOption(
                            id: 3,
                            name: "Oat Milk",
                            price: 0.50,
                            currency: "USD",
                            isDefault: true
                        )
                    ]
                )
            ]
        )
    }
}
