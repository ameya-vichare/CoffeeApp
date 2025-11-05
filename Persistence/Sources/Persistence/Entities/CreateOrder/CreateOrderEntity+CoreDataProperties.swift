//
//  CreateOrderEntity+CoreDataProperties.swift
//  Coffee App
//
//  Created by Ameya on 04/11/25.
//
//

public import Foundation
public import CoreData

extension CreateOrderEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CreateOrderEntity> {
        return NSFetchRequest<CreateOrderEntity>(entityName: "CreateOrderEntity")
    }

    @NSManaged public var userId: Int16
}
