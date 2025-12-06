//
//  AuthAPIProtocol.swift
//  AuthModule
//
//  Created by Ameya on 05/12/25.
//

import AppModels
import Networking

public protocol AuthAPIProtocol {
    func loginUser(config: APIConfig) async throws -> UserSession
}

