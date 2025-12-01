//
//  MenuModifierBottomSheetPriceComputeUsecase.swift
//  CoffeeModule
//
//  Created by Ameya on 11/11/25.
//

public protocol MenuModifierBottomSheetPriceComputeUsecaseProtocol {
    func getTotalPrice(selectedItemViewModels: [DefaultMenuModifierSelectionCellViewModel], quantitySelection: Int) -> Double
}

public final class MenuModifierBottomSheetPriceComputeUsecase: MenuModifierBottomSheetPriceComputeUsecaseProtocol {
    public init() {}
    
    public func getTotalPrice(selectedItemViewModels: [DefaultMenuModifierSelectionCellViewModel], quantitySelection: Int) -> Double {
        let itemPrice = selectedItemViewModels
            .reduce(0.0) { $0 + $1.price }
        
        return itemPrice * Double(quantitySelection)
    }
}

