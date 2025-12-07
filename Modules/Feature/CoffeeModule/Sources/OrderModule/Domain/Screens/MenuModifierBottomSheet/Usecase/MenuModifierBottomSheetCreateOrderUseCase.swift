//
//  MenuModifierBottomSheetCreateOrderUseCase.swift
//  CoffeeModule
//
//  Created by Ameya on 11/11/25.
//

import AppCore

public protocol MenuModifierBottomSheetCreateOrderUseCaseProtocol {
    func buildCreateOrderItem(
        selectedItemViewModels: [DefaultMenuModifierSelectionCellViewModel],
        id: Int,
        quantitySelection: Int
    ) -> CreateOrderItem
}

public class MenuModifierBottomSheetCreateOrderUseCase: MenuModifierBottomSheetCreateOrderUseCaseProtocol {
    public init() {}
    
    public func buildCreateOrderItem(
        selectedItemViewModels: [DefaultMenuModifierSelectionCellViewModel],
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
