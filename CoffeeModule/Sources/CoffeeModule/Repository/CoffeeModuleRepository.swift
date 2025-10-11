//
//  CoffeeModuleRepository.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import Combine
import AppModels
import Networking

public protocol CoffeeModuleRepository {
    func getCoffeeOrders(config: APIConfig) -> Future<[Order], NetworkError>
}
