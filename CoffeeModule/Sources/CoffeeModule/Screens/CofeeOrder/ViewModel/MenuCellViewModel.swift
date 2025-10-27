//
//  MenuCellViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 24/10/25.
//

import Foundation
import AppModels

final class MenuCellViewModel: ObservableObject {
    let name: String
    let currency: String
    let price: Double
    let displayPrice: String
    let description: String
    let imageURL: URL?
    let modifiers: [MenuModifier]

    @Published var quantitySelection: Int = 0
    
    init(
        name: String,
        currency: String,
        price: Double,
        description: String,
        imageURL: String,
        modifiers: [MenuModifier]
    ) {
        self.name = name
        self.currency = currency
        self.price = price
        self.displayPrice = price.formatPrice()
        self.description = description
        self.imageURL = URL(string: imageURL ?? "")
        self.modifiers = modifiers
    }
}

struct MenuModifierCellItem: Identifiable, Equatable {
    let id: String
    let type: MenuModifierCellType
    
    static func == (lhs: MenuModifierCellItem, rhs: MenuModifierCellItem) -> Bool {
        lhs.id == rhs.id
    }
}

enum MenuModifierCellType {
    case modifer(vm: MenuModifierViewModel)
}

final class MenuModifierBottomSheetViewModel: ObservableObject {
    let modifierViewModels: [MenuModifierViewModel]
    let modifiers: [MenuModifier]
    
    init(modifiers: [MenuModifier]) {
        self.modifiers = modifiers
        
        let menuModifierViewModels: [MenuModifierViewModel] = modifiers.compactMap { (menuModifier) -> MenuModifierViewModel? in
            guard let options = menuModifier.options else { return nil }

            // Build option cell view models with explicit element type
            let menuModifierCellViewModels: [MenuModifierCellViewModel] = options.map { option in
                MenuModifierCellViewModel(
                    id: option.id ?? 0,
                    name: option.name ?? "",
                    price: option.price ?? 0.0,
                    currency: option.currency ?? "",
                    isDefault: option.isDefault ?? false
                )
            }

            return MenuModifierViewModel(
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


final class MenuModifierViewModel: Identifiable, ObservableObject {
    let id: Int
    let name: String
    var displayDescription: String
    let options: [MenuModifierCellViewModel]
    
    init(
        id: Int,
        name: String,
        minSelection: Int,
        maxSelection: Int,
        options: [MenuModifierCellViewModel]
    ) {
        self.id = id
        self.name = name.capitalized
        
        self.displayDescription = ""
        if minSelection > 0 {
            self.displayDescription += "Required • Select any \(minSelection) option"
        } else {
            self.displayDescription += "Optional"
        }
        
        self.options = options
    }
    
    deinit {
        print("PRINT: deinit MenuModifierViewModel")
    }
}

enum MenuModifierSelectionType: String {
    case single
    case multiple
}

final class MenuModifierCellViewModel: Identifiable, ObservableObject {
    let id: Int
    let name: String
    let price: Double
    let displayPrice: String
    let currency: String
    let isDefault: Bool
    
    @Published var isSelected: Bool = false
    
    init(id: Int, name: String, price: Double, currency: String, isDefault: Bool) {
        self.id = id
        self.name = name
        self.price = price
        self.displayPrice = price.formatPrice()
        self.currency = currency
        self.isDefault = isDefault
        
        if isDefault {
            isSelected = true
        }
    }
    
    deinit {
        "PRINT: deinit MenuModifierCellViewModel"
    }
}
