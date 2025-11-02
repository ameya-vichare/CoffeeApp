//
//  MenuModifierViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 27/10/25.
//

import Foundation
import AppModels
import Combine

final class MenuModifierCategoryCellViewModel: Identifiable, ObservableObject {
    let id: Int
    let name: String
    var displayDescription: String
    let options: [MenuModifierSelectionCellViewModel]
    let selectionType: MenuSelectionType
    
    private(set) var priceComputePublisher = PassthroughSubject<Void, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        menuModifier: MenuModifier,
        options: [MenuModifierSelectionCellViewModel]
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
        
        self.bindChildren()
    }
    
    private func bindChildren() {
        let merged = Publishers.MergeMany(options.map { $0.selectionPassthroughSubject})
        
        merged
            .receive(on: DispatchQueue.main)
            .sink { [weak self] id in
                guard let self = self,
                      selectionType == .single
                else {
                    self?.computeTotalPrice()
                    return
                }
                
                /// Deselect all other items
                for option in self.options where option.id != id {
                    option.isSelected = false
                }
                self.computeTotalPrice()
            }
            .store(in: &cancellables)
    }
    
    private func computeTotalPrice() {
        self.priceComputePublisher.send()
    }
    
    deinit {
        print("PRINT: deinit MenuModifierViewModel")
    }
}
