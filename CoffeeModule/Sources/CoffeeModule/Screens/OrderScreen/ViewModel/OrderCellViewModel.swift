//
//  OrderCellViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import AppUtils
import Foundation
import AppModels

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
        self.displayTotalPriceLabel = "\(order.currency ?? "") \(order.totalPrice ?? "")"
        self.statusDisplayLabel = order.status?.rawValue ?? ""
        self.itemsViewModel = itemsViewModel
        
        if let createdAt = order.createdAt?.formatDate(dateFormat: DateFormat.shortDate) {
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
        item: OrderItem
    ) {
        self.name = item.name ?? ""
        self.customisation = item.modifier
            .compactMap { $0.name }.joined(separator: ", ")
        self.imageURL = URL(string: item.imageURL ?? "")
        self.displayPriceLabel = "\(item.currency ?? "") \(item.totalPrice ?? "")"
        self.displayQuantityLabel = "x\(item.quantity ?? "")"
    }
}
