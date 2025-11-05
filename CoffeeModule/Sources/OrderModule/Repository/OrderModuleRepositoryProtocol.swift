//
//  OrderModuleRepositoryProtocol.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import AppModels
import Networking

public protocol OrderModuleRepositoryProtocol {
    func getOrders(config: APIConfig) async throws -> [Order]
    func getMenu(config: APIConfig) async throws -> MenuResponse
    func createOrder(config: APIConfig) async throws -> CreateOrderResponse
}
