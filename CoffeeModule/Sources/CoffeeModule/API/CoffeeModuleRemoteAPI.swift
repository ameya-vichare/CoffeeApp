//
//  CoffeeModuleRemoteAPI.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import Combine
import AppModels
import Networking

public final class CoffeeModuleRemoteAPI: RemoteAPI {
    let networkService: NetworkService
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func getOrders(config: APIConfig) async throws -> [Order] {
        let networkRequest = NetworkRequest(apiConfig: config)
        return try await self.networkService.perform(request: networkRequest, response: [Order].self)
    }
}
