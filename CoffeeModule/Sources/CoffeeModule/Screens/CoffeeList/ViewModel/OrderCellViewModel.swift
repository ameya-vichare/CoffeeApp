//
//  OrderCellViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import AppUtils
import Foundation

struct OrderCellViewModel {
    let id: String
    let userName: String
    let createdAt: String
    let displayTotalPriceLabel: String
    let statusDisplayLabel: String
    let items: [OrderItemCellViewModel]
    
    init(
        id: String,
        userName: String,
        createdAt: String,
        totalPrice: String,
        currency: String,
        status: String,
        items: [OrderItemCellViewModel]
    ) {
        self.id = id
        self.userName = userName
        self.displayTotalPriceLabel = "\(currency) \(totalPrice)"
        self.statusDisplayLabel = status
        self.items = items
        
        if let createdAt = createdAt.formatDate(dateFormat: DateFormat.shortDate) {
            self.createdAt = createdAt
        } else {
            self.createdAt = ""
        }
    }
}

struct OrderItemCellViewModel: Identifiable {
    let id: UUID = UUID()
    let name: String
    let customisation: String
    let imageURL: URL?
    let displayPriceLabel: String
    let displayQuantityLabel: String
    
    init(
        name: String,
        modifiers: [String],
        imageURL: String?,
        totalPrice: String,
        currency: String,
        quantity: String
    ) {
        self.name = name
        self.customisation = modifiers.joined(separator: ", ")
        self.imageURL = URL(string: imageURL ?? "")
        self.displayPriceLabel = "\(currency) \(totalPrice)"
        self.displayQuantityLabel = "x\(quantity)"
    }
}
