//
//  CoffeeModuleClientRepository.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import AppModels
import Networking

public final class CoffeeModuleClientRepository: CoffeeModuleRepository {
    let remoteAPI: RemoteAPI
    
    public init(remoteAPI: RemoteAPI) {
        self.remoteAPI = remoteAPI
    }
    
    public func getCoffeeOrders(config: APIConfig) async throws -> [Order] {
        try await self.remoteAPI.getOrders(config: config)
    }
}
