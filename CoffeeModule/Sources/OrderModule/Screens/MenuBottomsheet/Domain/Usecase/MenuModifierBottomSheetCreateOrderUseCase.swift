//
//  MenuModifierBottomSheetCreateOrderUseCase.swift
//  CoffeeModule
//
//  Created by Ameya on 11/11/25.
//

import AppModels

protocol MenuModifierBottomSheetCreateOrderUseCaseProtocol {
    func buildCreateOrderItem(
        selectedItemViewModels: [MenuModifierSelectionCellViewModel],
        id: Int,
        quantitySelection: Int
    ) -> CreateOrderItem
}

class MenuModifierBottomSheetCreateOrderUseCase: MenuModifierBottomSheetCreateOrderUseCaseProtocol {
    init() {}
    
    public func buildCreateOrderItem(
        selectedItemViewModels: [MenuModifierSelectionCellViewModel],
        id: Int,
        quantitySelection: Int
    ) -> CreateOrderItem {
        let selectedOptionIds: [Int] = selectedItemViewModels.map { $0.id }
        return CreateOrderItem(
            itemID: id,
            quantity: quantitySelection,
            optionIDs: selectedOptionIds
        )
    }
}
