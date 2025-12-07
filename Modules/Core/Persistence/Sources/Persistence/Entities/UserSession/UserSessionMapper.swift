//
//  UserSessionMapper.swift
//  Persistence
//
//  Created by Ameya on 06/12/25.
//

import AppCore
import CoreData

struct UserSessionMapper {
    func toDomain(entity: UserSessionEntity) -> UserSession {
        UserSession(
            userId: Int(entity.userId),
            userName: entity.userName,
            token: entity.token
        )
    }
    
    func toEntity(userSession: UserSession, in context: NSManagedObjectContext) -> UserSessionEntity {
        let entity = UserSessionEntity(context: context)
        entity.userId = Int16(userSession.userId)
        entity.userName = userSession.userName
        entity.token = userSession.token
        
        return entity
    }
}
