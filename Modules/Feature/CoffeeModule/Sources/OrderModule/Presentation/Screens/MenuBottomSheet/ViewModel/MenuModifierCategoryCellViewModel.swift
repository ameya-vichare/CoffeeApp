//
//  MenuModifierViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 27/10/25.
//

import Foundation
import AppCore
import Combine

protocol MenuModifierCategoryCellViewModelOutput {
    var priceComputePublisher: AnyPublisher<Void, Never> { get }
}

@MainActor
final class MenuModifierCategoryCellViewModel: Identifiable, ObservableObject, MenuModifierCategoryCellViewModelOutput {
    let id: Int
    let name: String
    var displayDescription: String
    let options: [DefaultMenuModifierSelectionCellViewModel]
    let selectionType: MenuSelectionType
    let deselectionUseCase: MenuModifierDeselectionUseCaseProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Output
    private var priceComputeSubject = PassthroughSubject<Void, Never>()
    var priceComputePublisher: AnyPublisher<Void, Never> {
        priceComputeSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init(
        menuModifier: MenuModifier,
        options: [DefaultMenuModifierSelectionCellViewModel],
        deselectionUseCase: MenuModifierDeselectionUseCaseProtocol
    ) {
        self.id = menuModifier.id ?? 0
        self.name = menuModifier.name?.capitalized ?? ""
        
        self.displayDescription = ""
        let minSelection = menuModifier.minSelect ?? 0
        if minSelection > 0 {
            self.displayDescription += "Required • Select any \(minSelection) option"
        } else {
            self.displayDescription += "Optional"
        }
        
        self.selectionType = menuModifier.selectionType ?? .single
        self.options = options
        
        self.deselectionUseCase = deselectionUseCase
        
        self.bindChildren()
    }
}

// MARK: - Bindings
extension MenuModifierCategoryCellViewModel {
    private func bindChildren() {
        let merged = Publishers.MergeMany(options.map { $0.itemSelectionPublisher})
        
        merged
            .receive(on: DispatchQueue.main)
            .sink { [weak self] id in
                guard let self else {
                    return
                }
                
                self.deselectionUseCase.deselectOtherItems(
                    selectionType: selectionType,
                    options: options,
                    currentSelectedId: id
                )
                
                self.computeTotalPrice()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Output
extension MenuModifierCategoryCellViewModel {
    private func computeTotalPrice() {
        self.priceComputeSubject.send()
    }
}
