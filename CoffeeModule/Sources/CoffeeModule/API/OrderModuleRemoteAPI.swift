//
//  CoffeeModuleRemoteAPI.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import AppModels
import Networking

public final class OrderModuleRemoteAPI: OrderModuleAPIProtocol {
    let networkService: NetworkService
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func getOrders(config: APIConfig) async throws -> [Order] {
        let networkRequest = NetworkRequest(apiConfig: config)
        return try await self.networkService.perform(request: networkRequest, responseType: [Order].self)
    }
    
    public func getMenu(config: any Networking.APIConfig) async throws -> MenuResponse {
        let networkRequest = NetworkRequest(apiConfig: config)
        return try await self.networkService.perform(request: networkRequest, responseType: MenuResponse.self)
    }
    
    public func createOrder(config: APIConfig) async throws -> CreateOrderResponse {
        let networkRequest = NetworkRequest(apiConfig: config)
        return try await self.networkService.perform(request: networkRequest, responseType: CreateOrderResponse.self)
    }
}
