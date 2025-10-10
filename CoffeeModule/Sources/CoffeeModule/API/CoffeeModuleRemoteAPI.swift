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
    
    public func getOrders(config: APIConfig) -> Future<[Coffee], NetworkError> {
        let networkRequest = NetworkRequest(apiConfig: config)
        
        return Future<[Coffee], NetworkError> { [weak self] promise in
            self?.networkService
                .perform(request: networkRequest, response: [Coffee].self)
                .sink { error in
                } receiveValue: { coffeeList in
                    promise(.success(coffeeList))
                }
        }
    }
}
