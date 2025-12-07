//
//  GetOrdersUseCase.swift
//  CoffeeModule
//
//  Created by Ameya on 11/11/25.
//

import AppCore

public protocol GetOrdersUseCaseProtocol {
    func execute() async throws -> [Order]
}

public final class GetOrdersUseCase: GetOrdersUseCaseProtocol {
    private let repository: OrderModuleRepositoryProtocol
    
    public init(repository: OrderModuleRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() async throws -> [Order] {
        let getCoffeeOrderConfig = OrderEndpoint.getOrders
        return try await repository.getOrders(config: getCoffeeOrderConfig)
    }
}
