//
//  RemoteAPI.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import AppCore
import Networking

public protocol OrderModuleAPIProtocol: Sendable {
    func getOrders(config: APIConfig) async throws -> OrderResponse
    func getMenu(config: APIConfig) async throws -> MenuResponse
    func createOrder(config: APIConfig) async throws -> CreateOrderResponse
}
