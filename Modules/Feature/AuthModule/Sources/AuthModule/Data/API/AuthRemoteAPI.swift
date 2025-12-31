//
//  AuthRemoteAPI.swift
//  AuthModule
//
//  Created by Ameya on 05/12/25.
//

import AppCore
import Networking

public final class AuthRemoteAPI: AuthAPIProtocol {
    let networkService: NetworkService
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func loginUser(config: APIConfig) async throws -> UserSession {
        let networkRequest = NetworkRequest(apiConfig: config)
        let response = try await self.networkService.perform(
            request: networkRequest,
            responseType: UserSession.self
        )
        
        return response
    }
    
    public func logoutUser(config: APIConfig) async throws -> UserLogoutResponse {
        let networkRequest = NetworkRequest(apiConfig: config)
        let response = try await self.networkService.perform(
            request: networkRequest,
            responseType: UserLogoutResponse.self
        )
        
        return response
    }
}

