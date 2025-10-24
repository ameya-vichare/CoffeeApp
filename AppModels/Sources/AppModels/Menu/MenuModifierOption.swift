//
//  MenuModifierOption.swift
//  AppModels
//
//  Created by Ameya on 24/10/25.
//

import Foundation

public struct MenuModifierOption: Decodable {
    let id: Int?
    let name: String?
    let price: Float?
    let currency: String?
    
    public init(id: Int?, name: String?, price: Float?, currency: String?) {
        self.id = id
        self.name = name
        self.price = price
        self.currency = currency
    }
}
