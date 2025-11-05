//
//  CreateOrderCoreDataStore.swift
//  Persistence
//
//  Created by Ameya on 04/11/25.
//

import AppModels
import CoreData

public class OrderModuleCoreDataStore: OrderModuleDataStoreProtocol {
    private let container: NSPersistentContainer
    private let mapper = CreateOrderMapper()
    
    public init(container: NSPersistentContainer) {
        self.container = container
    }

    public func storeOrder(order: CreateOrder) async throws {
        try await container.performBackgroundTask { context in
            let entity = self.mapper.toEntity(order: order, in: context)
            if context.hasChanges {
                try context.save()
            }
        }
    }
    
    public func fetchCreateOrder() async throws -> [CreateOrder] {
        try await container.viewContext.perform {
            let fetchRequest = CreateOrderEntity.fetchRequest()
            let entities = try self.container.viewContext.fetch(fetchRequest)
            return entities.map { self.mapper.toDomain(entity: $0) }
        }
    }
}
