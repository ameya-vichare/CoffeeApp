//
//  CoffeeModuleClientRepository.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import AppModels
import Networking

public final class CoffeeModuleClientRepository: CoffeeModuleRepository {
    let remoteAPI: OrderModuleAPIProtocol
    
    public init(remoteAPI: OrderModuleAPIProtocol) {
        self.remoteAPI = remoteAPI
    }
    
    public func getCoffeeOrders(config: APIConfig) async throws -> [Order] {
        try await self.remoteAPI.getOrders(config: config)
    }
    
    public func getMenu(config: any Networking.APIConfig) async throws -> MenuResponse {
        try await self.remoteAPI.getMenu(config: config)
    }
    
    public func createOrder(config: APIConfig) async throws -> CreateOrderResponse {
        try await self.remoteAPI.createOrder(config: config)
    }
}
