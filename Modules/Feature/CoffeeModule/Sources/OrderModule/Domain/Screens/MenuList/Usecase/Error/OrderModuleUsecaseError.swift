//
//  OrderModuleUsecaseError.swift
//  CoffeeModule
//
//  Created by Ameya on 09/11/25.
//


import Foundation
import AppCore
import NetworkMonitoring

public enum OrderModuleUsecaseError: Error {
    case creatingOrderFailed
    
    var title: String {
        switch self {
        case .creatingOrderFailed:
            return "Order Failed"
        }
    }
    
    var message: String {
        switch self {
        case .creatingOrderFailed:
            return "We couldn't send your order, but we will retry!"
        }
    }
}
