//
//  MenuModifierViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 27/10/25.
//

import Foundation
import AppModels

final class MenuModifierCellViewModel: Identifiable, ObservableObject {
    let id: Int
    let name: String
    var displayDescription: String
    let options: [MenuModifierSelectionViewModel]
    
    init(
        id: Int,
        name: String,
        minSelection: Int,
        maxSelection: Int,
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
        
        self.options = options
    }
    
    deinit {
        print("PRINT: deinit MenuModifierViewModel")
    }
}
