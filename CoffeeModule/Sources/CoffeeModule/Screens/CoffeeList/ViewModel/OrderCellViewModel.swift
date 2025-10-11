//
//  OrderCellViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import AppUtils
import Foundation

final class OrderCellViewModel {
    let id: String
    let userName: String
    let createdAt: String
    let totalPrice: String
    let currency: String
    let items: [OrderItemCellViewModel]
    
    init(
        id: String,
        userName: String,
        createdAt: String,
        totalPrice: String,
        currency: String,
        items: [OrderItemCellViewModel]
    ) {
        self.id = id
        self.userName = userName
        self.totalPrice = totalPrice
        self.currency = currency
        self.items = items
        
        if let createdAt = createdAt.formatDate(dateFormat: DateFormat.shortDate) {
            self.createdAt = createdAt
        } else {
            self.createdAt = ""
        }
    }
}

final class OrderItemCellViewModel: Identifiable {
    let name: String
    let size: String
    let extras: String
    let imageURL: URL?
    let displayPriceLabel: String
    let displayQuantityLabel: String
    
    init(
        name: String,
        size: String,
        extras: String,
        imageURL: String?,
        totalPrice: String,
        currency: String,
        quantity: String
    ) {
        self.name = name
        self.size = size
        self.extras = extras
        self.imageURL = URL(string: imageURL ?? "")
        self.displayPriceLabel = "\(currency) \(totalPrice)"
        self.displayQuantityLabel = "x\(quantity)"
    }
}
