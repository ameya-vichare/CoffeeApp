//
//  UserSessionEntity.swift
//  Persistence
//
//  Created by Ameya on 06/12/25.
//

import Foundation
import CoreData

@objc(UserSessionEntity)
public class UserSessionEntity: NSManagedObject {

}

extension UserSessionEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserSessionEntity> {
        return NSFetchRequest<UserSessionEntity>(entityName: "UserSessionEntity")
    }

    @NSManaged public var userId: Int16
    @NSManaged public var userName: String
    @NSManaged public var token: String
}
