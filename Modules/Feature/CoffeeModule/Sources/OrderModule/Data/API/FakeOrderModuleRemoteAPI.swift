//
//  FakeCoffeeModuleRemoteAPI.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import AppCore
import Networking

public final class FakeOrderModuleRemoteAPI: OrderModuleAPIProtocol {
    public init () {}
    
    public func getOrders(config: APIConfig) async throws -> OrderResponse {
        OrderResponse(
            orders: [
                Order.createFake()
            ],
            pagination: OrderPagination(
                limit: 0,
                nextCursor: "",
                hasMore: true
            )
        )
    }
    
    public func getMenu(config: any Networking.APIConfig) async throws -> MenuResponse {
        MenuResponse(
            menu: [
                MenuItem.createFake()
            ]
        )
    }
    
    public func createOrder(config: APIConfig) async throws -> CreateOrderResponse {
        CreateOrderResponse.createFake()
    }
}
