//
//  RetryPendingOrdersUsecase.swift
//  CoffeeModule
//
//  Created by Ameya on 09/11/25.
//

public protocol RetryPendingOrdersUsecaseProtocol {
    func execute() async throws
}

public final class RetryPendingOrdersUsecase: RetryPendingOrdersUsecaseProtocol {
    public let repository: OrderModuleRepositoryProtocol
    
    public init(repository: OrderModuleRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() async throws {
        do {
            try await self.repository.retryPendingOrders()
        } catch {
            throw error
        }
    }
}
