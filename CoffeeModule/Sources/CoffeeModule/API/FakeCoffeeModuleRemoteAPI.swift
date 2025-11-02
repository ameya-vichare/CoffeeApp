//
//  FakeCoffeeModuleRemoteAPI.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import AppModels
import Networking

public final class FakeCoffeeModuleRemoteAPI: OrderModuleAPIProtocol {
    public init () {}
    
    public func getOrders(config: APIConfig) async throws -> [Order] {
        return [
            Order.createFake()
        ]
    }
    
    public func getMenu(config: any Networking.APIConfig) async throws -> MenuResponse {
        return MenuResponse(
            menu: [
                MenuItem.createFake()
            ]
        )
    }
}
