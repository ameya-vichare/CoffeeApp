//
//  CreateOrderItemEntity.swift
//  Persistence
//
//  Created by Ameya on 05/11/25.
//

import Foundation
import CoreData

@objc(CreateOrderItemEntity)
public class CreateOrderItemEntity: NSManagedObject {

}

extension CreateOrderItemEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CreateOrderItemEntity> {
        return NSFetchRequest<CreateOrderItemEntity>(entityName: "CreateOrderItemEntity")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var itemID: Int16
    @NSManaged public var quantity: Int16
    @NSManaged public var optionIDs: [Int]?
}
