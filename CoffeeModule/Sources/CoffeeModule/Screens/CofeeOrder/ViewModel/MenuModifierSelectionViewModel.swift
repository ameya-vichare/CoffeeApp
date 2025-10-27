//
//  MenuModifierCellViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 27/10/25.
//

import Foundation
import AppModels

final class MenuModifierSelectionViewModel: Identifiable, ObservableObject {
    let id: Int
    let name: String
    let price: Double
    let displayPrice: String
    let currency: String
    let isDefault: Bool
    
    @Published var isSelected: Bool = false
    
    init(id: Int, name: String, price: Double, currency: String, isDefault: Bool) {
        self.id = id
        self.name = name
        self.price = price
        self.displayPrice = price.formatPrice()
        self.currency = currency
        self.isDefault = isDefault
        
        if isDefault {
            isSelected = true
        }
    }
    
    deinit {
        "PRINT: deinit MenuModifierCellViewModel"
    }
}
