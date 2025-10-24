//
//  CoffeeListCellItem.swift
//  CoffeeModule
//
//  Created by Ameya on 24/10/25.
//

import Foundation

struct CoffeeListCellItem: Identifiable, Equatable {
    let id: String
    let type: CoffeeListCellType
    
    static func == (lhs: CoffeeListCellItem, rhs: CoffeeListCellItem) -> Bool {
        lhs.id == rhs.id
    }
}

enum CoffeeListCellType {
    case coffeeOrder(vm: OrderCellViewModel)
}
