//
//  FakeOrderModuleRepository.swift
//  CoffeeModule
//
//  Created by Ameya on 16/11/25.
//

import Networking
import AppModels

final class FakeOrderModuleRepository: OrderModuleRepositoryProtocol {
    enum Result {
        case getOrdersSuccess([Order])
        case getOrdersFailure(NetworkError)
        case getMenuSuccess(MenuResponse)
        case getMenuFailure(NetworkError)
        case createOrderSuccess(CreateOrderResponse)
        case createOrderFailure(NetworkError)
    }
    
    let result: Result
    
    init(result: Result) {
        self.result = result
    }
    
    func getOrders(config: APIConfig) async throws -> [Order] {
        switch result {
        case .getOrdersSuccess(let orders):
            return orders
        case .getOrdersFailure(let error):
            throw error
        default:
            break
        }
        
        throw NetworkError.cancelled
    }

    func getMenu(config: APIConfig) async throws -> MenuResponse {
        switch result {
        case .getMenuSuccess(let menu):
            return menu
        case .getMenuFailure(let error):
            throw error
        default:
            break
        }
        
        throw NetworkError.cancelled
    }

    func createOrder(config: APIConfig) async throws -> CreateOrderResponse {
        switch result {
        case .createOrderSuccess(let order):
            return order
        case .createOrderFailure(let error):
            throw error
        default:
            break
        }
        
        throw NetworkError.cancelled
    }

    func storeCreateOrder(order: CreateOrder) async throws {
        
    }

    func retryPendingOrders() async throws {
        
    }
}
