//
//  OrderModuleRepositoryProtocol.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import AppCore
import Networking

public protocol OrderModuleRepositoryProtocol: Sendable {
    func getOrders(config: APIConfig) async throws -> [Order]
    func getMenu(config: APIConfig) async throws -> MenuResponse
    func createOrder(config: APIConfig) async throws -> CreateOrderResponse
    
    func storeCreateOrder(order: CreateOrder) async throws
    func retryPendingOrders() async throws
}
