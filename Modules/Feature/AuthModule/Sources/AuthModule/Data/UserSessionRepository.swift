//
//  UserSessionRepository.swift
//  AuthModule
//
//  Created by Ameya on 01/12/25.
//

import AppModels
import Persistence

public protocol UserSessionRepositoryProtocol {
    func getUserSession() async throws -> UserSession
}

public final class UserSessionRepository: UserSessionRepositoryProtocol {
    let dataStore: AuthModuleDataStoreProtocol
    
    public init(dataStore: AuthModuleDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    public func getUserSession() async throws -> UserSession {
        try await self.dataStore.getUserSession()
    }
}
