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
                            OrderModifier(
                                group: "Toppings",
                                name: "Whipped cream"
                            )
                        ]
                    )
                ]
            )
        ]
    }
    
    public func getMenu(config: any Networking.APIConfig) async throws -> MenuResponse {
        return MenuResponse(
                menu: [MenuItem(
                    id: 8,
                    name: "Hot Americano",
                    description: "A shot of espresso, diluted to create a smooth black coffee.",
                    imageURL: "https://images.unsplash.com/photo-1669872484166-e11b9638b50e",
                    basePrice: 14.00,
                    currency: "USD",
                    modifiers: [
                        MenuModifier(
                            id: 1,
                            name: "Milk Type",
                            selectionType: .single,
                            minSelect: 1,
                            maxSelect: 1,
                            options: [
                                MenuModifierOption(
                                    id: 3,
                                    name: "Oat Milk",
                                    price: 0.50,
                                    currency: "USD",
                                    isDefault: true
                                )
                            ]
                        )
                    ]
                )
            ]
        )
    }
}
