//
//  MenuListCellItem.swift
//  CoffeeModule
//
//  Created by Ameya on 24/10/25.
//

import Foundation

struct MenuListCellItem: Identifiable, Equatable {
    let id: String
    let type: MenuListCellType
    
    static func == (lhs: MenuListCellItem, rhs: MenuListCellItem) -> Bool {
        rhs.id == lhs.id
    }
}

enum MenuListCellType {
    case mainMenu(vm: MenuCellViewModel)
}
