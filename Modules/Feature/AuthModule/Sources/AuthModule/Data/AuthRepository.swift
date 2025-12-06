//
//  UserSessionRepository.swift
//  AuthModule
//
//  Created by Ameya on 01/12/25.
//

import AppModels
import Persistence

public final class AuthRepository: AuthRepositoryProtocol {
    let dataStore: AuthModuleDataStoreProtocol
    
    public init(dataStore: AuthModuleDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    public func getUserSession() async throws -> UserSession {
        try await self.dataStore.getUserSession()
    }
}
