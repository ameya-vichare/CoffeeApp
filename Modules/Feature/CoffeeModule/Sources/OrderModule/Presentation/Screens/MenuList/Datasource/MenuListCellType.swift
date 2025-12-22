//
//  MenuListCellType.swift
//  CoffeeModule
//
//  Created by Ameya on 24/10/25.
//

import Foundation

public enum MenuListCellType: Identifiable {
    public var id: String {
        switch self {
        case .mainMenu(let vm):
            return "\(vm.id)"
        }
    }

    case mainMenu(vm: MenuListCellViewModel)
}
