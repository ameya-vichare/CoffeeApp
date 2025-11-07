//
//  FakeOrderModuleDataStore.swift
//  Persistence
//
//  Created by Ameya on 05/11/25.
//

import AppModels

public class FakeOrderModuleDataStore: OrderModuleDataStoreProtocol {
    public init () {
        
    }
    
    public func storeCreateOrder(order: CreateOrder) async throws {
        
    }
    
    public func fetchCreateOrder() async throws -> [CreateOrder] {
        []
    }
    
    public func deleteAllCreateOrders() async throws {

    }
}
