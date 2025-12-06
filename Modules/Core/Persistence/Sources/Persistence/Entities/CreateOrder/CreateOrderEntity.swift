//
//  CreateOrderEntity+CoreDataClass.swift
//  Coffee App
//
//  Created by Ameya on 04/11/25.
//
//

import Foundation
import CoreData

@objc(CreateOrderEntity)
public class CreateOrderEntity: NSManagedObject {

}

extension CreateOrderEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CreateOrderEntity> {
        return NSFetchRequest<CreateOrderEntity>(entityName: "CreateOrderEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var items: NSOrderedSet?
}
