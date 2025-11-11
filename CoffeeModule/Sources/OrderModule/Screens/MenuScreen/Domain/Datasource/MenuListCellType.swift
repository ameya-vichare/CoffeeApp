//
//  MenuListCellType.swift
//  CoffeeModule
//
//  Created by Ameya on 24/10/25.
//

import Foundation

enum MenuListCellType: Identifiable {
    var id: String {
        switch self {
        case .mainMenu(let vm):
            return "\(vm.id)"
        }
    }

    case mainMenu(vm: MenuListCellViewModel)
}
