//
//  MenuModifierCellViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 27/10/25.
//

import Foundation
import AppModels
import Combine

final class MenuModifierSelectionCellViewModel: Identifiable, ObservableObject {
    let id: Int
    let name: String
    let price: Double
    let displayPrice: String
    let currency: String
    let isDefault: Bool
    let minimumSelection: Int
    
    @Published var isSelected: Bool = false
    private(set) var selectionPassthroughSubject = PassthroughSubject<Int, Never>()
    
    init(id: Int, name: String, price: Double, currency: String, isDefault: Bool, minimumSelection: Int) {
        self.id = id
        self.name = name
        self.price = price
        self.displayPrice = price.formatPrice()
        self.currency = currency
        self.isDefault = isDefault
        self.minimumSelection = minimumSelection
        
        if isDefault {
            isSelected = true
        }
    }
    
    func toggleSelection() {
        switch minimumSelection {
        case 0:
            toggleAndPublish()
        case 1 where !isSelected:
            toggleAndPublish()
        default:
            break
        }
    }
    
    private func toggleAndPublish() {
        isSelected.toggle()
        selectionPassthroughSubject.send(id)
    }
    
    deinit {
        "PRINT: deinit MenuModifierCellViewModel"
    }
}
