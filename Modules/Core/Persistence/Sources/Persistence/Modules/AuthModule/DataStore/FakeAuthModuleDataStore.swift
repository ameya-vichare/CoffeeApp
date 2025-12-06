//
//  FakeAuthModuleDataStore.swift
//  Persistence
//
//  Created by Ameya on 05/12/25.
//

import AppModels

public final class FakeAuthModuleDataStore: AuthModuleDataStoreProtocol {
    public init() {}
    
    public func getUserSession() throws -> UserSession {
        throw AuthModuleDataStoreError.userSessionNotFound
    }
}

