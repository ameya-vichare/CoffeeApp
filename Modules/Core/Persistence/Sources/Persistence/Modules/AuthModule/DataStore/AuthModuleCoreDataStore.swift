//
//  AuthModuleCoreDataStore.swift
//  Persistence
//
//  Created by Ameya on 01/12/25.
//

import AppModels

public protocol AuthModuleDataStoreProtocol {
    func getUserSession() throws -> UserSession
}

public final class AuthModuleCoreDataStore: AuthModuleDataStoreProtocol {
    public init() {}
    
    public func getUserSession() throws -> UserSession {
        UserSession(userId: "", userName: "", token: "")
    }
}
