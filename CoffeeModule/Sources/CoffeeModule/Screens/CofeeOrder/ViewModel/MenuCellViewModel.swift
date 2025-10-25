//
//  MenuCellViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 24/10/25.
//

import Foundation

final class MenuCellViewModel {
    let name: String
    let currency: String
    let price: Double
    let displayPrice: String
    let description: String
    let imageURL: URL?
    
    init(
        name: String,
        currency: String,
        price: Double,
        description: String,
        imageURL: String
    ) {
        self.name = name
        self.currency = currency
        self.price = price
        self.displayPrice = price.formatPrice()
        self.description = description
        self.imageURL = URL(string: imageURL ?? "")
    }
}
