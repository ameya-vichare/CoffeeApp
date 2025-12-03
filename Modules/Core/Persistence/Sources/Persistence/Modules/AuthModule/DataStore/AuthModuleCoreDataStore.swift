//
//  AuthModuleCoreDataStore.swift
//  Persistence
//
//  Created by Ameya on 01/12/25.
//

import AppModels

public enum AuthModuleDataStoreError: Error {
    case userSessionNotFound
}

public final class AuthModuleCoreDataStore: AuthModuleDataStoreProtocol {
    public init() {}
    
    public func getUserSession() throws -> UserSession {
        throw AuthModuleDataStoreError.userSessionNotFound
    }
}
