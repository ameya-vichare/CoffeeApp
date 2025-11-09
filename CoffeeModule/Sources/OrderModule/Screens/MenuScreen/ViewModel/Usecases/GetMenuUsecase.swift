//
//  GetMenuUsecase.swift
//  CoffeeModule
//
//  Created by Ameya on 09/11/25.
//

import Foundation
import AppModels
import AppEndpoints

public protocol GetMenuUsecaseProtocol {
    func execute() async throws -> MenuResponse
}

public final class GetMenuUsecase: GetMenuUsecaseProtocol {
    public let repository: OrderModuleRepositoryProtocol
    
    public init(repository: OrderModuleRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() async throws -> MenuResponse {
        let getMenuAPIConfig = MenuEndpoint.getMenuItems
        return try await self.repository.getMenu(config: getMenuAPIConfig)
    }
}
