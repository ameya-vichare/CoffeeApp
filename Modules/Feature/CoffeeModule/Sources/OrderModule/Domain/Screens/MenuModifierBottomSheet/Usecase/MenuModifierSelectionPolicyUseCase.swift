//
//  MenuModifierSelectionPolicyUseCase.swift
//  CoffeeModule
//
//  Created by Ameya on 12/11/25.
//

protocol MenuModifierSelectionPolicyUseCaseProtocol {
    func canToggleSelection(minimumSelection: Int, isSelected: Bool) -> Bool
}

class MenuModifierSelectionPolicyUseCase: MenuModifierSelectionPolicyUseCaseProtocol {
    func canToggleSelection(minimumSelection: Int, isSelected: Bool) -> Bool {
        switch minimumSelection {
        case 0:
            return true
        case 1 where !isSelected:
            return true
        default:
            return false
        }
    }
}
