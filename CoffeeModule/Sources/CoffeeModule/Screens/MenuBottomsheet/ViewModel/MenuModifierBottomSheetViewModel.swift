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
    
    let id: Int
    let currency: String
    let name: String
    let imageURL: URL?
    
    private var totalPrice: Double = 0.0
    private var quantitySelection: Int = 1
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        modifiers: [MenuModifier],
        id: Int,
        currency: String,
        name: String,
        imageURL: URL?
    ) {
        self.currency = currency
        self.id = id
        self.name = name
        self.imageURL = imageURL
        
        let menuModifierViewModels: [MenuModifierCategoryCellViewModel] = modifiers.compactMap { (menuModifier) -> MenuModifierCategoryCellViewModel? in
            guard let options = menuModifier.options else { return nil }

            let menuModifierCellViewModels: [MenuModifierSelectionCellViewModel] = options.map {
                MenuModifierSelectionCellViewModel(option: $0, minimumSelection: menuModifier.minSelect ?? 0)
            }

            return MenuModifierCategoryCellViewModel(
                menuModifier: menuModifier,
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
        
        footerViewModel.addItemPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.createOrderItem()
            }
            .store(in: &cancellables)
    }
    
    private func computeTotalPrice() {
        let itemPrice = getSelectedItemViewModels()
            .reduce(0.0) { $0 + $1.price }
        
        self.totalPrice = itemPrice * Double(quantitySelection)
        self.footerViewModel.setTotalPrice(price: self.totalPrice)
    }
    
    private func createOrderItem() {
        let selectedOptionIds: [Int] = getSelectedItemViewModels().map { $0.id }
        let createOrderItem = CreateOrderItem(
            itemID: id,
            quantity: quantitySelection,
            optionIDs: selectedOptionIds
        )
        
        print(createOrderItem)
    }
    
    private func getSelectedItemViewModels() -> [MenuModifierSelectionCellViewModel] {
        self.modifierViewModels.flatMap { $0.options }
            .filter { $0.isSelected }
    }
}

