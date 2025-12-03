//
//  AuthModuleDataStoreProtocol.swift
//  Persistence
//
//  Created by Ameya on 03/12/25.
//

import AppModels

public protocol AuthModuleDataStoreProtocol {
    func getUserSession() throws -> UserSession
}
