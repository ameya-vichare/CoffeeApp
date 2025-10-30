//
//  MenuModifierViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 27/10/25.
//

import Foundation
import AppModels
import Combine

final class MenuModifierCellViewModel: Identifiable, ObservableObject {
    let id: Int
    let name: String
    var displayDescription: String
    let options: [MenuModifierSelectionViewModel]
    let selectionType: MenuSelectionType
    
    private(set) var priceComputePublisher = PassthroughSubject<Void, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        id: Int,
        name: String,
        minSelection: Int,
        maxSelection: Int,
        selectionType: MenuSelectionType,
        options: [MenuModifierSelectionViewModel]
    ) {
        self.id = id
        self.name = name.capitalized
        
        self.displayDescription = ""
        if minSelection > 0 {
            self.displayDescription += "Required • Select any \(minSelection) option"
        } else {
            self.displayDescription += "Optional"
        }
        
        self.selectionType = selectionType
        self.options = options
        
        self.bindChildren()
    }
    
    private func bindChildren() {
        let merged = Publishers.MergeMany(options.map { $0.selectionPassthroughSubject})
        
        merged.sink { [weak self] id in
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
