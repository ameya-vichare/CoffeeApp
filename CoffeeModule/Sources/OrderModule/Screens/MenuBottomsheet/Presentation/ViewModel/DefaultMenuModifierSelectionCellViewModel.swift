//
//  MenuModifierCellViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 27/10/25.
//

import Foundation
import AppModels
import Combine

protocol MenuModifierSelectionCellViewModelInput {
    func setSelected(_ isSelected: Bool)
    func toggleSelection()
}

protocol MenuModifierSelectionCellViewModelOutput {
    var isSelected: Bool { get }
    var itemSelectionPublisher: AnyPublisher<Int, Never> { get }
}

typealias MenuModifierSelectionCellViewModel = MenuModifierSelectionCellViewModelInput & MenuModifierSelectionCellViewModelOutput

@MainActor
final class DefaultMenuModifierSelectionCellViewModel: Identifiable, ObservableObject, MenuModifierSelectionCellViewModel {
    let id: Int
    let name: String
    let price: Double
    let displayPrice: String
    let currency: String
    let isDefault: Bool
    let minimumSelection: Int
    
    let selectionPolicyUseCase: MenuModifierSelectionPolicyUseCaseProtocol
    
    // MARK: - Output
    @Published var isSelected: Bool = false
    private var itemSelectionSubject = PassthroughSubject<Int, Never>()
    var itemSelectionPublisher: AnyPublisher<Int, Never> {
        itemSelectionSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init(
        option: MenuModifierOption,
        minimumSelection: Int,
        selectionPolicyUseCase: MenuModifierSelectionPolicyUseCaseProtocol
    ) {
        self.id = option.id ?? 0
        self.name = option.name ?? ""
        self.price = option.price ?? 0
        self.displayPrice = price.formatPrice()
        self.currency = option.currency ?? ""
        self.isDefault = option.isDefault ?? false
        self.minimumSelection = minimumSelection
        
        if isDefault {
            isSelected = true
        }
        
        self.selectionPolicyUseCase = selectionPolicyUseCase
    }
}

// MARK: - Input
extension DefaultMenuModifierSelectionCellViewModel {
    func setSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
    }
    
    func toggleSelection() {
        let canToggle: Bool = self.selectionPolicyUseCase.canToggleSelection(
            minimumSelection: minimumSelection,
            isSelected: isSelected
        )
        
        if canToggle {
            toggleAndPublish()
        }
    }
}

// MARK: - Output
extension DefaultMenuModifierSelectionCellViewModel {
    private func toggleAndPublish() {
        isSelected.toggle()
        itemSelectionSubject.send(id)
    }
}


