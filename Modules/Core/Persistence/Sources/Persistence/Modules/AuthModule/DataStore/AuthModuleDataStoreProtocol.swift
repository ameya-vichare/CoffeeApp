//
//  AuthModuleDataStoreProtocol.swift
//  Persistence
//
//  Created by Ameya on 03/12/25.
//

import AppCore

public protocol AuthModuleDataStoreProtocol {
    func getUserSession() async throws -> UserSession
    func storeUserSession(userSession: UserSession) async throws
}
