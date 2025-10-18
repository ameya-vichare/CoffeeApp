//
//  RemoteAPI.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import AppModels
import Networking

public protocol RemoteAPI {
    func getOrders(config: APIConfig) async throws -> [Order]
}
