//
//  FakeCoffeeModuleRemoteAPI.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import AppModels
import Networking

public final class FakeCoffeeModuleRemoteAPI: RemoteAPI {
    public init () {}
    
    public func getOrders(config: APIConfig) async throws -> [Order] {
        return [
            Order(
                id: "1",
                createdAt: "2025-09-13T09:13:15.732796+00:00",
                userName: "Ameya",
                currency: "USD",
                totalPrice: "12",
                status: .pending,
                items: [
                    OrderItem(
                        name: "Latte",
                        imageURL: "https://via.placeholder.com/150",
                        size: "Medium",
                        quantity: "1",
                        totalPrice: "12",
                        currency: "USD",
                        modifier: [
                            Modifier(
                                group: "Toppings",
                                name: "Whipped cream"
                            )
                        ]
                    )
                ]
            )
        ]
    }
}
