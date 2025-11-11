//
//  OrderModuleUsecaseError.swift
//  CoffeeModule
//
//  Created by Ameya on 09/11/25.
//


import Foundation
import AppModels
import AppEndpoints
import NetworkMonitoring

public enum OrderModuleUsecaseError: Error {
    case creatingOrderFailed
    case orderRetryFailed
    
    var title: String {
        switch self {
        case .creatingOrderFailed:
            return "Order Failed"
        case .orderRetryFailed:
            return "Order Retry Failed"
        }
    }
    
    var message: String {
        switch self {
        case .creatingOrderFailed:
            return "We couldn't send your order, but we will retry!"
        case .orderRetryFailed:
            return "We couldn't send your previously failed order."
        }
    }
}
