//
//  OrderModuleClientRepository.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import Foundation
import AppModels
import Networking
import Persistence
import Combine
import AppEndpoints

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
    
    public func retryPendingOrders() async {
        do {
            let orders = try await self.dataStore.fetchCreateOrder()
            print(orders)
            guard !orders.isEmpty else { return }
            
            let createOrder = CreateOrder(
                userId: orders.first?.userId ?? 1,
                items: orders.flatMap { $0.items }
            )
            let createOrderAPIConfig = CreateOrderEndpoint.createOrder(data: createOrder)
            try await self.remoteAPI.createOrder(config: createOrderAPIConfig)
            
            try await self.dataStore.deleteAllCreateOrders()
        } catch {
            print(error.localizedDescription)
        }
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
