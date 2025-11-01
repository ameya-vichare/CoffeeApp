//
//  MenuModifierBottomSheetViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 27/10/25.
//

import Foundation
import AppModels
import Combine

final class MenuModifierBottomSheetViewModel: ObservableObject {
    let modifierViewModels: [MenuModifierCategoryCellViewModel]
    let modifiers: [MenuModifier]
    private var cancellables: Set<AnyCancellable> = []
    @Published private(set) var totalPrice: Double = 0.0
    
    init(modifiers: [MenuModifier]) {
        self.modifiers = modifiers
        
        let menuModifierViewModels: [MenuModifierCategoryCellViewModel] = modifiers.compactMap { (menuModifier) -> MenuModifierCategoryCellViewModel? in
            guard let options = menuModifier.options else { return nil }

            let menuModifierCellViewModels: [MenuModifierSelectionCellViewModel] = options.map { option in
                MenuModifierSelectionCellViewModel(
                    id: option.id ?? 0,
                    name: option.name ?? "",
                    price: option.price ?? 0.0,
                    currency: option.currency ?? "",
                    isDefault: option.isDefault ?? false,
                    minimumSelection: menuModifier.minSelect ?? 0
                )
            }

            return MenuModifierCategoryCellViewModel(
                id: menuModifier.id ?? 0,
                name: menuModifier.name ?? "",
                minSelection: menuModifier.minSelect ?? 0,
                maxSelection: menuModifier.maxSelect ?? 0,
                selectionType: menuModifier.selectionType ?? .single,
                options: menuModifierCellViewModels
            )
        }
        
        self.modifierViewModels = menuModifierViewModels
        self.bindChildren()
        self.computeTotalPrice()
    }
    
    private func bindChildren() {
        let merged = Publishers.MergeMany(self.modifierViewModels.map { $0.priceComputePublisher})

        merged.sink { [weak self] _ in
            self?.computeTotalPrice()
        }
        .store(in: &cancellables)
    }
    
    private func computeTotalPrice() {
        self.totalPrice = self.modifierViewModels.flatMap { $0.options }
            .filter { $0.isSelected }
            .reduce(0.0) { $0 + $1.price }
    }

    deinit {
        print("PRINT: deinit MenuModifierBottomSheetViewModel")
    }
}

