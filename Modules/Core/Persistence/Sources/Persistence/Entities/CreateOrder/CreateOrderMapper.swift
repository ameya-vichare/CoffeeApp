//
//  CreateOrderMapper.swift
//  Persistence
//
//  Created by Ameya on 05/11/25.
//

import AppModels
import CoreData

struct CreateOrderMapper {
    func toDomain(entity: CreateOrderEntity) -> CreateOrder {
        var items: [CreateOrderItem] = []
        if let createOrderItems = entity.items?.array as? [CreateOrderItemEntity] {
            items = createOrderItems.map {
                CreateOrderItem(
                    itemID: Int($0.itemID),
                    quantity: Int($0.quantity),
                    optionIDs: $0.optionIDs ?? []
                )
            }
        }
        
        return CreateOrder(userId: Int(entity.userId), items: items)
    }
    
    func toEntity(order: CreateOrder, in context: NSManagedObjectContext) -> CreateOrderEntity {
        let entity = CreateOrderEntity(context: context)
        entity.id = UUID()
        entity.userId = Int16(order.userId)
        
        var items: [CreateOrderItemEntity] = []
        order.items.forEach { item in
            let itemEntity = CreateOrderItemEntity(context: context)
            itemEntity.id = UUID()
            itemEntity.itemID = Int16(item.itemID)
            itemEntity.quantity = Int16(item.quantity)
            itemEntity.optionIDs = item.optionIDs
            
            items.append(itemEntity)
        }
        
        entity.items = NSOrderedSet(array: items)
        return entity
    }
}
