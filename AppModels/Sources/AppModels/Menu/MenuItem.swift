//
//  Menu.swift
//  AppModels
//
//  Created by Ameya on 24/10/25.
//

import Foundation

//{
//            "id": 8,
//            "type": "coffee",
//            "name": "Hot Americano",
//            "description": "A shot of espresso, diluted to create a smooth black coffee.",
//            "image_url": "https://images.unsplash.com/photo-1669872484166-e11b9638b50e",
//            "base_price": "14.00",
//            "sizes": [
//                {
//                    "id": 4,
//                    "code": "S",
//                    "label": "Small",
//                    "price": "14.00"
//                },
//                {
//                    "id": 5,
//                    "code": "M",
//                    "label": "Medium",
//                    "price": "15.00"
//                },
//                {
//                    "id": 6,
//                    "code": "L",
//                    "label": "Large",
//                    "price": "17.00"
//                }
//            ],
//            "modifier_groups": [
//                {
//                    "id": 1,
//                    "name": "Milk Type",
//                    "selection_type": "single",
//                    "min_select": 1,
//                    "max_select": 1,
//                    "position": 0,
//                    "options": [
//                        {
//                            "id": 3,
//                            "name": "Oat Milk",
//                            "price": "0.50",
//                            "override_price": null,
//                            "is_default": false,
//                            "active": true
//                        },
//                        {
//                            "id": 4,
//                            "name": "Dairy Milk",
//                            "price": "0.00",
//                            "override_price": null,
//                            "is_default": true,
//                            "active": true
//                        }
//                    ]
//                },
//                {
//                    "id": 2,
//                    "name": "Syrup",
//                    "selection_type": "single",
//                    "min_select": 0,
//                    "max_select": 1,
//                    "position": 0,
//                    "options": [
//                        {
//                            "id": 5,
//                            "name": "Hazelnut",
//                            "price": "0.50",
//                            "override_price": null,
//                            "is_default": false,
//                            "active": true
//                        },
//                        {
//                            "id": 6,
//                            "name": "Caramel",
//                            "price": "0.50",
//                            "override_price": null,
//                            "is_default": false,
//                            "active": true
//                        }
//                    ]
//                }
//            ]
//        }

public struct MenuItem: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let imageURL: String?
    let basePrice: Double?
    let basePriceCurrency: String?
    let sizes: [MenuSize]?
    let modifiers: [MenuModifier]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageURL = "image_url"
        case basePrice = "base_price"
        case basePriceCurrency = "base_price_currency"
        case sizes
        case modifiers = "modifier_groups"
    }
    
    public init(id: Int?, name: String?, description: String?, imageURL: String?, basePrice: Double?, basePriceCurrency: String?, sizes: [MenuSize]?, modifiers: [MenuModifier]?) {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.basePrice = basePrice
        self.basePriceCurrency = basePriceCurrency
        self.sizes = sizes
        self.modifiers = modifiers
    }
}
