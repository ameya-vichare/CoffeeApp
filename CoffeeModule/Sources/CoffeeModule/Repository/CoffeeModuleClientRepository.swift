//
//  CoffeeModuleClientRepository.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import Combine
import AppModels
import Networking

final class CoffeeModuleClientRepository: CoffeeModuleRepository {
    let remoteAPI: RemoteAPI
    
    init(remoteAPI: RemoteAPI) {
        self.remoteAPI = remoteAPI
    }
    
    func getCoffeeOrders(config: APIConfig) -> Future<[Coffee], NetworkError> {
        self.remoteAPI.getOrders(config: config)
    }
}
