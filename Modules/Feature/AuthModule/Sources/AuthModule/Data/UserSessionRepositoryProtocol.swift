//
//  UserSessionRepositoryProtocol.swift
//  AuthModule
//
//  Created by Ameya on 03/12/25.
//

import AppModels

public protocol UserSessionRepositoryProtocol {
    func getUserSession() async throws -> UserSession
}
