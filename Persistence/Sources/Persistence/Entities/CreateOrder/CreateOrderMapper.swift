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
        CreateOrder(userId: Int(entity.userId))
    }
    
    func toEntity(order: CreateOrder, in context: NSManagedObjectContext) -> CreateOrderEntity {
        let entity = CreateOrderEntity(context: context)
        entity.userId = Int16(order.userId)
        return entity
    }
}
