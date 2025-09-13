//
//  CoffeeModuleRemoteAPI.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import Combine
import AppModels
import Networking

final class CoffeeModuleRemoteAPI: RemoteAPI {
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getOrders(config: APIConfig) -> Future<[Coffee], NetworkError> {
        let networkRequest = NetworkRequest(apiConfig: config)
        
        return Future<[Coffee], NetworkError> { [weak self] promise in
            self?.networkClient
                .perform(request: networkRequest, response: [Coffee].self)
                .sink { error in
                } receiveValue: { coffeeList in
                    promise(.success(coffeeList))
                }
        }
    }
}
