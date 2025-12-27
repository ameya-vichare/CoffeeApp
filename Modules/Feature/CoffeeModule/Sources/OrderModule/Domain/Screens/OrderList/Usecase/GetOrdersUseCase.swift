//
//  GetOrdersUseCase.swift
//  CoffeeModule
//
//  Created by Ameya on 11/11/25.
//

import AppCore

public protocol GetOrdersUseCaseProtocol {
    func execute(using pageData: OrderPagination?) async throws -> OrderResponse
}

public final class GetOrdersUseCase: GetOrdersUseCaseProtocol {
    private let repository: OrderModuleRepositoryProtocol
    
    public init(repository: OrderModuleRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(using pageData: OrderPagination?) async throws -> OrderResponse {
        let getCoffeeOrderConfig = OrderEndpoint.getOrders(
            cursor: pageData?.nextCursor
        )
        return try await repository.getOrders(config: getCoffeeOrderConfig)
    }
}
