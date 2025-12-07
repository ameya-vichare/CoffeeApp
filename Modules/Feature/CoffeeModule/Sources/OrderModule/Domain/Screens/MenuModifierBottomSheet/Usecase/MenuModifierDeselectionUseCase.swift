//
//  MenuModifierDeselectionUseCase.swift
//  CoffeeModule
//
//  Created by Ameya on 12/11/25.
//

import AppCore

protocol MenuModifierDeselectionUseCaseProtocol {
    func deselectOtherItems(
        selectionType: MenuSelectionType,
        options: [DefaultMenuModifierSelectionCellViewModel],
        currentSelectedId: Int
    )
}

final class MenuModifierDeselectionUseCase: MenuModifierDeselectionUseCaseProtocol {
    @MainActor func deselectOtherItems(
        selectionType: AppModels.MenuSelectionType,
        options: [DefaultMenuModifierSelectionCellViewModel],
        currentSelectedId: Int
    ) {
        guard selectionType == .single else {
            return
        }
        /// Deselect all other items
        for option in options where option.id != currentSelectedId {
            option.setSelected(false)
        }
    }
}
