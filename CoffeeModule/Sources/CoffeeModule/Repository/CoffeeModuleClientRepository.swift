//
//  CoffeeModuleClientRepository.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import Combine
import AppModels
import Networking

public final class CoffeeModuleClientRepository: CoffeeModuleRepository {
    let remoteAPI: RemoteAPI
    
    public init(remoteAPI: RemoteAPI) {
        self.remoteAPI = remoteAPI
    }
    
    public func getCoffeeOrders(config: APIConfig) -> Future<[Order], NetworkError> {
        self.remoteAPI.getOrders(config: config)
    }
}
