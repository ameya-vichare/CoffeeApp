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
    
    public init(id: Int?, name: String?, price: Double?, currency: String?) {
        self.id = id
        self.name = name
        self.price = price
        self.currency = currency
    }
}
