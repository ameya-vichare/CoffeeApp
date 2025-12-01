//
//  MenuCellViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 24/10/25.
//

import Foundation
import AppModels
import Combine

protocol MenuListCellViewModelOutput {
    var id: Int { get }
    var name: String { get }
    var currency: String { get }
    var displayPrice: String { get }
    var description: String { get }
    var imageURL: URL? { get }
}

protocol MenuListCellViewModelActions {
    func showMenuModifierBottomsheet()
}

typealias MenuListCellViewModel = MenuListCellViewModelActions & MenuListCellViewModelOutput 

struct DefaultMenuListCellViewModel: MenuListCellViewModel {
    let id: Int
    let name: String
    let currency: String
    let price: Double
    let displayPrice: String
    let description: String
    let imageURL: URL?
    let modifiers: [MenuModifier]

    let onShowMenuModifierBottomSheet: (() -> Void)

    init(
        menuItem: MenuItem,
        onShowMenuModifierBottomSheet: @escaping (() -> Void)
    ) {
        self.id = menuItem.id ?? 0
        self.name = menuItem.name ?? ""
        self.currency = menuItem.currency ?? ""
        self.price = menuItem.basePrice ?? 0.0
        self.displayPrice = price.formatPrice()
        self.description = menuItem.description ?? ""
        self.imageURL = URL(string: menuItem.imageURL ?? "")
        self.modifiers = menuItem.modifiers ?? []
        
        self.onShowMenuModifierBottomSheet = onShowMenuModifierBottomSheet
    }
}

// MARK: - Actions
extension DefaultMenuListCellViewModel {
    func showMenuModifierBottomsheet() {
        onShowMenuModifierBottomSheet()
    }
}


