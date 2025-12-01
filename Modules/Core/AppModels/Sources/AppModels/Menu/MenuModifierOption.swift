//
//  MenuModifierOption.swift
//  AppModels
//
//  Created by Ameya on 24/10/25.
//

import Foundation

public struct MenuModifierOption: Decodable {
    public let id: Int?
    public let name: String?
    public let price: Double?
    public let currency: String?
    public let isDefault: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, name, price, currency, isDefault = "is_default"
    }
    
    public init(
        id: Int?,
        name: String?,
        price: Double?,
        currency: String?,
        isDefault: Bool
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.currency = currency
        self.isDefault = isDefault
    }
}
