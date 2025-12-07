//
//  UserSessionRepository.swift
//  AuthModule
//
//  Created by Ameya on 01/12/25.
//

import AppCore
import Persistence
import Networking

public final class AuthRepository: AuthRepositoryProtocol {
    let dataStore: AuthModuleDataStoreProtocol
    let remoteAPI: AuthAPIProtocol
    
    public init(dataStore: AuthModuleDataStoreProtocol, remoteAPI: AuthAPIProtocol) {
        self.dataStore = dataStore
        self.remoteAPI = remoteAPI
    }
    
    public func getUserSession() async throws -> UserSession {
        try await self.dataStore.getUserSession()
    }
    
    public func loginUser(config: APIConfig) async throws -> UserSession {
        let userSession = try await self.remoteAPI.loginUser(config: config)
        do {
            try await self.dataStore.storeUserSession(userSession: userSession)
        } catch {}
        
        return userSession
    }
}
