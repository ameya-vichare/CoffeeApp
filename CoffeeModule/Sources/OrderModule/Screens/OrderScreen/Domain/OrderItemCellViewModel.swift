//
//  OrderItemCellViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 11/11/25.
//

import Foundation
import AppModels

// View model for order's items
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
