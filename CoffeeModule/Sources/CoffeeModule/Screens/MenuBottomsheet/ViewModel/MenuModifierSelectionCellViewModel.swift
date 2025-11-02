//
//  MenuModifierCellViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 27/10/25.
//

import Foundation
import AppModels
import Combine

@MainActor
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
    
    init(
        option: MenuModifierOption,
        minimumSelection: Int
    ) {
        self.id = option.id ?? 0
        self.name = option.name ?? ""
        self.price = option.price ?? 0
        self.displayPrice = price.formatPrice()
        self.currency = option.currency ?? ""
        self.isDefault = option.isDefault ?? false
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
}
