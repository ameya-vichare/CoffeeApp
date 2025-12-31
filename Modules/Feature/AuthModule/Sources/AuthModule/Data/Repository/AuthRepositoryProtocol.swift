//
//  UserSessionRepositoryProtocol.swift
//  AuthModule
//
//  Created by Ameya on 03/12/25.
//

import AppCore
import Networking

public protocol AuthRepositoryProtocol {
    func getUserSession() async throws -> UserSession
    func loginUser(config: APIConfig) async throws -> UserSession
    func logoutUser(config: APIConfig) async throws
}
