//
//  OrderModuleDataStoreProtocol.swift
//  Persistence
//
//  Created by Ameya on 05/11/25.
//

import AppModels

public protocol OrderModuleDataStoreProtocol {
    func storeCreateOrder(order: CreateOrder) async throws
    func fetchCreateOrder() async throws -> [CreateOrder]
    func deleteAllCreateOrders() async throws
}
