//
//  UserLogoutUseCase.swift
//  ProfileModule
//
//  Created by Ameya on 29/12/25.
//

import Foundation
import Networking
import AppEndpoints
import AuthModule

public protocol UserLogoutUseCaseProtocol {
    func execute() async throws
}

public final class UserLogoutUseCase: UserLogoutUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    public init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() async throws {
        let logoutAPIConfig = LogoutEndpoint.logout
        _ = try await repository.logoutUser(config: logoutAPIConfig)
    }
}

