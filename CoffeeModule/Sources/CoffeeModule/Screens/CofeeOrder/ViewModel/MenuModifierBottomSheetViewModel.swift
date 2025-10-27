//
//  MenuModifierBottomSheetViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 27/10/25.
//

import Foundation
import AppModels

final class MenuModifierBottomSheetViewModel: ObservableObject {
    let modifierViewModels: [MenuModifierCellViewModel]
    let modifiers: [MenuModifier]
    
    init(modifiers: [MenuModifier]) {
        self.modifiers = modifiers
        
        let menuModifierViewModels: [MenuModifierCellViewModel] = modifiers.compactMap { (menuModifier) -> MenuModifierCellViewModel? in
            guard let options = menuModifier.options else { return nil }

            let menuModifierCellViewModels: [MenuModifierSelectionViewModel] = options.map { option in
                MenuModifierSelectionViewModel(
                    id: option.id ?? 0,
                    name: option.name ?? "",
                    price: option.price ?? 0.0,
                    currency: option.currency ?? "",
                    isDefault: option.isDefault ?? false
                )
            }

            return MenuModifierCellViewModel(
                id: menuModifier.id ?? 0,
                name: menuModifier.name ?? "",
                minSelection: menuModifier.minSelect ?? 0,
                maxSelection: menuModifier.maxSelect ?? 0,
                options: menuModifierCellViewModels
            )
        }
        
        self.modifierViewModels = menuModifierViewModels
    }

    deinit {
        print("PRINT: deinit MenuModifierBottomSheetViewModel")
    }
}
