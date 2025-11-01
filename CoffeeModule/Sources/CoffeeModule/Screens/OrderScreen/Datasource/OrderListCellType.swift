//
//  OrderListCellType.swift
//  CoffeeModule
//
//  Created by Ameya on 24/10/25.
//

import Foundation

enum OrderListCellType: Identifiable {
    var id: String {
        switch self {
        case .coffeeOrder(let vm):
            return vm.id
        }
    }
    
    case coffeeOrder(vm: OrderCellViewModel)
}
