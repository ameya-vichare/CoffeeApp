//
//  CoffeeModuleRepository.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import AppModels
import Networking

public protocol CoffeeModuleRepository {
    func getCoffeeOrders(config: APIConfig) async throws -> [Order]
    func getMenu(config: APIConfig) async throws -> Menu
}
