//
//  AuthModuleCoreDataStore.swift
//  Persistence
//
//  Created by Ameya on 01/12/25.
//

import AppCore
import CoreData

public enum AuthModuleDataStoreError: Error {
    case userSessionNotFound
}

public final class AuthModuleCoreDataStore: AuthModuleDataStoreProtocol {
    let container: NSPersistentContainer
    let mapper = UserSessionMapper()
    
    public init(
        container: NSPersistentContainer
    ) {
        self.container = container
    }
    
    public func getUserSession() async throws -> UserSession {
        try await container.viewContext.perform {
            let fetchRequest = UserSessionEntity.fetchRequest()
            if let entity = try self.container.viewContext.fetch(fetchRequest).first {
                return self.mapper.toDomain(entity: entity)
            } else {
                throw AuthModuleDataStoreError.userSessionNotFound
            }
        }
    }
    
    public func storeUserSession(userSession: UserSession) async throws {
        try await container.performBackgroundTask { context in
            let entity = self.mapper.toEntity(userSession: userSession, in: context)
            if context.hasChanges {
                try context.save()
            }
        }
    }
    
    public func deleteUserSession() async throws {
        try await container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserSessionEntity.fetchRequest()
            if let entity = try context.fetch(fetchRequest).first as? UserSessionEntity {
                context.delete(entity)
                if context.hasChanges {
                    try context.save()
                }
            }
        }
    }
}
