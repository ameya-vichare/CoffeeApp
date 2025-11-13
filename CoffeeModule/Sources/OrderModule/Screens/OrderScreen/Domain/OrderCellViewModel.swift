//
//  OrderCellViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import AppUtils
import AppModels

// View model for the single order
struct OrderCellViewModel {
    let id: String
    let userName: String
    let createdAt: String
    let displayTotalPriceLabel: String
    let statusDisplayLabel: String
    let itemsViewModel: [OrderItemCellViewModel]
    
    init(
        order: Order,
        itemsViewModel: [OrderItemCellViewModel]
    ) {
        self.id = order.id ?? ""
        self.userName = order.userName ?? ""
        
        if let totalPrice = order.totalPrice, let currency = order.currency {
            self.displayTotalPriceLabel = "\(currency) \(totalPrice)"
        } else {
            self.displayTotalPriceLabel = ""
        }
        
        self.statusDisplayLabel = order.status?.rawValue ?? ""
        self.itemsViewModel = itemsViewModel
        
        if let createdAt = order.createdAt?.formatDate(dateFormat: DateFormat.shortDate) {
            self.createdAt = createdAt
        } else {
            self.createdAt = ""
        }
    }
}

