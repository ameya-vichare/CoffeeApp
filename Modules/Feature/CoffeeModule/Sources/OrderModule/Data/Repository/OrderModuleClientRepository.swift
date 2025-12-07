//
//  OrderModuleClientRepository.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import Foundation
import AppCore
import Networking
import Persistence
import Combine

public final class OrderModuleClientRepository: OrderModuleRepositoryProtocol, @unchecked Sendable {
    let remoteAPI: OrderModuleAPIProtocol
    let dataStore: OrderModuleDataStoreProtocol
    
    public init(
        remoteAPI: OrderModuleAPIProtocol,
        dataStore: OrderModuleDataStoreProtocol
    ) {
        self.remoteAPI = remoteAPI
        self.dataStore = dataStore
    }
    
    public func retryPendingOrders() async throws {
        let orders = try await self.dataStore.fetchCreateOrder()
        guard !orders.isEmpty else {
            return
        }
        
        let createOrder = CreateOrder(
            items: orders.flatMap { $0.items }
        )
        let createOrderAPIConfig = CreateOrderEndpoint.createOrder(data: createOrder)
        try await self.remoteAPI.createOrder(config: createOrderAPIConfig)
        
        try await self.dataStore.deleteAllCreateOrders()
    }
    
    public func storeCreateOrder(order: CreateOrder) async throws {
        try await self.dataStore.storeCreateOrder(order: order)
    }
    
    public func getOrders(config: APIConfig) async throws -> [Order] {
        try await self.remoteAPI.getOrders(config: config)
    }
    
    public func getMenu(config: APIConfig) async throws -> MenuResponse {
        try await self.remoteAPI.getMenu(config: config)
    }
    
    public func createOrder(config: APIConfig) async throws -> CreateOrderResponse {
        try await self.remoteAPI.createOrder(config: config)
    }
}
