//
//  GetOrdersUseCase.swift
//  CoffeeModule
//
//  Created by Ameya on 11/11/25.
//

import AppEndpoints
import AppModels

public protocol GetOrdersUseCaseProtocol {
    func execute() async throws -> [Order]
}

public final class GetOrdersUseCase: GetOrdersUseCaseProtocol {
    private let repository: OrderModuleClientRepository
    
    public init(repository: OrderModuleClientRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [Order] {
        let getCoffeeOrderConfig = OrderEndpoint.getOrders
        return try await repository.getOrders(config: getCoffeeOrderConfig)
    }
}
