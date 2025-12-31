//
//  FakeAuthRemoteAPI.swift
//  AuthModule
//
//  Created by Ameya on 05/12/25.
//

import AppCore
import Networking

public final class FakeAuthRemoteAPI: AuthAPIProtocol {
    public init() {}
    
    public func loginUser(config: APIConfig) async throws -> UserSession {
        UserSession(userId: 1, userName: "testuser", token: "fake-token")
    }
    
    public func logoutUser(config: any Networking.APIConfig) async throws {
    }
}

