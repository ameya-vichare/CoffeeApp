//
//  OrderModuleClientRepository.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import AppModels
import Networking
import Persistence

public final class OrderModuleClientRepository: OrderModuleRepositoryProtocol {
    let remoteAPI: OrderModuleAPIProtocol
    let dataStore: OrderModuleDataStoreProtocol
    
    public init(remoteAPI: OrderModuleAPIProtocol, dataStore: OrderModuleDataStoreProtocol) {
        self.remoteAPI = remoteAPI
        self.dataStore = dataStore
    }
    
    public func getOrders(config: APIConfig) async throws -> [Order] {
        try await self.remoteAPI.getOrders(config: config)
    }
    
    public func getMenu(config: any Networking.APIConfig) async throws -> MenuResponse {
        try await self.remoteAPI.getMenu(config: config)
    }
    
    public func createOrder(config: APIConfig) async throws -> CreateOrderResponse {
        do {
            try await self.dataStore.storeOrder(order: CreateOrder(userId: 1))
        } catch {
            print(error.localizedDescription)
        }
        
        let orders = try await self.dataStore.fetchCreateOrder()
        print(orders)
        
        
        return try await self.remoteAPI.createOrder(config: config)
    }
}
