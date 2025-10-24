//
//  File.swift
//  CoffeeModule
//
//  Created by Ameya on 24/10/25.
//

import Foundation

@Observable
final class MenuCellViewModel {
    let name: String
    let currency: String
    let price: Double
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
        self.description = description
        self.imageURL = URL(string: imageURL ?? "")
    }
}
