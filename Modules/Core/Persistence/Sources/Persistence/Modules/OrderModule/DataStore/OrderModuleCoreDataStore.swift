//
//  CreateOrderCoreDataStore.swift
//  Persistence
//
//  Created by Ameya on 04/11/25.
//

import AppCore
import CoreData

public final class OrderModuleCoreDataStore: OrderModuleDataStoreProtocol {
    private let container: NSPersistentContainer
    private let mapper = CreateOrderMapper()
    
    public init(container: NSPersistentContainer) {
        self.container = container
    }

    public func storeCreateOrder(order: CreateOrder) async throws {
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
    
    public func deleteAllCreateOrders() async throws {
        try await container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CreateOrderEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try context.execute(deleteRequest)
        }
    }
}
