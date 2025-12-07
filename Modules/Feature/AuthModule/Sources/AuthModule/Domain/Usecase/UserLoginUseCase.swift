//
//  UserLoginUseCase.swift
//  AuthModule
//
//  Created by Ameya on 05/12/25.
//

import AppCore
import Networking

public protocol UserLoginUseCaseProtocol {
    func execute(userName: String, password: String) async throws -> UserSession
}

public final class UserLoginUseCase: UserLoginUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    public init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(userName: String, password: String) async throws -> UserSession {
        let userLogin = UserLogin(userName: userName, password: password)
        let loginAPIConfig = LoginEndpoint.login(data: userLogin)
        return try await repository.loginUser(config: loginAPIConfig)
    }
}

