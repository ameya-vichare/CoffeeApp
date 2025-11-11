//
//  MenuModifierBottomSheetFooterViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 02/11/25.
//

import Foundation
import Combine

protocol MenuModifierBottomSheetFooterViewModelInput {
    func incrementQuantity()
    func decrementQuantity()
    func setTotalPrice(price: Double)
    func addItemPressed()
}

protocol MenuModifierBottomSheetFooterViewModelOutput {
    var quantitySelection: Int { get }
    var totalPrice: Double { get }
    var addItemPublisher: AnyPublisher<Void, Never> { get }
}

typealias MenuModifierBottomSheetFooterViewModel = MenuModifierBottomSheetFooterViewModelInput & MenuModifierBottomSheetFooterViewModelOutput

@MainActor
final class DefaultMenuModifierBottomSheetFooterViewModel: ObservableObject, MenuModifierBottomSheetFooterViewModel {
    let currency: String
    
    // MARK: - Output
    @Published private(set) var quantitySelection: Int = 1
    @Published private(set) var totalPrice: Double = 0.0
    
    private(set) var addItemSubject = PassthroughSubject<Void, Never>()
    var addItemPublisher: AnyPublisher<Void, Never> {
        addItemSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init(currency: String) {
        self.currency = currency
    }
}

// MARK: - Input
extension DefaultMenuModifierBottomSheetFooterViewModel {
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
        self.addItemSubject.send()
    }
}
