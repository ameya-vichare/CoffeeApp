//
//  MenuCellViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 24/10/25.
//

import Foundation
import AppModels

final class MenuListCellViewModel: ObservableObject {
    let id: Int
    let name: String
    let currency: String
    let price: Double
    let displayPrice: String
    let description: String
    let imageURL: URL?
    let modifiers: [MenuModifier]

    @Published var quantitySelection: Int = 0
    
    init(
        id: Int,
        name: String,
        currency: String,
        price: Double,
        description: String,
        imageURL: String,
        modifiers: [MenuModifier]
    ) {
        self.id = id
        self.name = name
        self.currency = currency
        self.price = price
        self.displayPrice = price.formatPrice()
        self.description = description
        self.imageURL = URL(string: imageURL ?? "")
        self.modifiers = modifiers
    }
}


