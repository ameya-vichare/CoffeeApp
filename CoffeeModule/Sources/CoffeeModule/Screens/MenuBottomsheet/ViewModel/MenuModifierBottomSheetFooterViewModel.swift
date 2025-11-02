//
//  MenuModifierBottomSheetFooterViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 02/11/25.
//

import Foundation
import Combine

@MainActor
final class MenuModifierBottomSheetFooterViewModel: ObservableObject {
    let currency: String
    
    @Published private(set) var quantitySelection: Int = 1
    @Published private(set) var totalPrice: Double = 0.0
    
    private(set) var addItemPublisher = PassthroughSubject<Void, Never>()
    
    init(currency: String) {
        self.currency = currency
    }
    
    func incrementQuantity() {
        quantitySelection += 1
    }
    
    func decrementQuantity() {
        quantitySelection = max(1, quantitySelection - 1)
    }
    
    func setTotalPrice(price: Double) {
        self.totalPrice = price
    }
    
    func addItemPressed() {
        self.addItemPublisher.send()
    }
}
