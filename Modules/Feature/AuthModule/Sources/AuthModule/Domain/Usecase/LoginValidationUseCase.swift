//
//  LoginValidationUseCase.swift
//  AuthModule
//
//  Created by Ameya on 05/12/25.
//

import Foundation

public protocol LoginValidationUseCaseProtocol {
    func validateUsername(_ username: String) -> Bool
    func validatePassword(_ password: String) -> Bool
}

public final class LoginValidationUseCase: LoginValidationUseCaseProtocol {
    public init() {}
    
    public func validateUsername(_ username: String) -> Bool {
        let username = username.trimmingCharacters(in: .whitespaces)
        return !username.isEmpty && username.count >= 4
    }
    
    public func validatePassword(_ password: String) -> Bool {
        let password = password.trimmingCharacters(in: .whitespaces)
        return password.count >= 8
    }
}

