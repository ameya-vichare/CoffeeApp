//
//  MenuModifierBottomSheetViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 27/10/25.
//

import Foundation
import AppModels
import Combine

@MainActor
final class MenuModifierBottomSheetViewModel: ObservableObject {
    let modifierViewModels: [MenuModifierCategoryCellViewModel]
    let footerViewModel: MenuModifierBottomSheetFooterViewModel
    let headerViewModel: MenuModifierBottomSheetHeaderViewModel
    let currency: String
    let name: String
    let imageURL: URL?
    
    private var totalPrice: Double = 0.0
    private var quantitySelection: Int = 1
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        modifiers: [MenuModifier],
        currency: String,
        name: String,
        imageURL: URL?
    ) {
        self.currency = currency
        self.name = name
        self.imageURL = imageURL
        
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
        self.footerViewModel = .init(currency: currency)
        self.headerViewModel = .init(name: name, imageURL: imageURL)
        
        self.bindChildren()
        self.computeTotalPrice()
    }
    
    private func bindChildren() {
        let merged = Publishers.MergeMany(self.modifierViewModels.map { $0.priceComputePublisher})

        merged
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.computeTotalPrice()
            }
            .store(in: &cancellables)
        
        footerViewModel.$quantitySelection
            .receive(on: DispatchQueue.main)
            .sink { [weak self] quantity in
                self?.quantitySelection = quantity
                self?.computeTotalPrice()
            }
            .store(in: &cancellables)
    }
    
    private func computeTotalPrice() {
        let itemPrice = self.modifierViewModels.flatMap { $0.options }
            .filter { $0.isSelected }
            .reduce(0.0) { $0 + $1.price }
        
        self.totalPrice = itemPrice * Double(quantitySelection)
        self.footerViewModel.setTotalPrice(price: self.totalPrice)
    }
}

