//
//  CreateOrderUsecase.swift
//  CoffeeModule
//
//  Created by Ameya on 09/11/25.
//

import Foundation
import AppCore
import NetworkMonitoring

public protocol CreateOrderUsecaseProtocol {
    func execute(using orderItem: CreateOrderItem) async throws -> CreateOrderResponse
}

public final class CreateOrderUsecase: CreateOrderUsecaseProtocol {
    public let repository: OrderModuleRepositoryProtocol
    public let networkMonitor: NetworkMonitoring
    
    public init(repository: OrderModuleRepositoryProtocol, networkMonitor: NetworkMonitoring) {
        self.repository = repository
        self.networkMonitor = networkMonitor
    }
    
    public func execute(using orderItem: CreateOrderItem) async throws -> CreateOrderResponse {
        let orderData = CreateOrder(items: [orderItem])
        let createOrderAPIConfig = CreateOrderEndpoint.createOrder(data: orderData)
        
        do {
            guard networkMonitor.status == .available else {
                try await self.repository.storeCreateOrder(order: orderData)
                throw OrderModuleUsecaseError.creatingOrderFailed
            }
            
            return try await self.repository.createOrder(config: createOrderAPIConfig)
        } catch {
            throw OrderModuleUsecaseError.creatingOrderFailed
        }
    }
}
