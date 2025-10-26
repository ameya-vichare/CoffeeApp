//
//  MenuCellViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 24/10/25.
//

import Foundation

final class MenuCellViewModel: ObservableObject {
    let name: String
    let currency: String
    let price: Double
    let displayPrice: String
    let description: String
    let imageURL: URL?
    
    let bottomSheetModel: MenuModifierBottomSheetViewModel
    
    @Published var quantitySelection: Int = 0
    
    init(
        name: String,
        currency: String,
        price: Double,
        description: String,
        imageURL: String,
        bottomSheetModel: MenuModifierBottomSheetViewModel
    ) {
        self.name = name
        self.currency = currency
        self.price = price
        self.displayPrice = price.formatPrice()
        self.description = description
        self.imageURL = URL(string: imageURL ?? "")
        self.bottomSheetModel = bottomSheetModel
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

final class MenuModifierBottomSheetViewModel {
    let modifierViewModels: [MenuModifierViewModel]
    
    init(modifierViewModels: [MenuModifierViewModel]) {
        self.modifierViewModels = modifierViewModels
    }
}

final class MenuModifierViewModel: Identifiable {
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
        }
        
        self.options = options
    }
}

enum MenuModifierSelectionType: String {
    case single
    case multiple
}

final class MenuModifierCellViewModel: Identifiable {
    let id: Int
    let name: String
    let price: Double
    let currency: String
    let isDefault: Bool
    
    init(id: Int, name: String, price: Double, currency: String, isDefault: Bool) {
        self.id = id
        self.name = name
        self.price = price
        self.currency = currency
        self.isDefault = isDefault
    }
}
