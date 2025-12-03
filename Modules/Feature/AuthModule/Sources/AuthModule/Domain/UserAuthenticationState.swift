//
//  UserAuthenticationState.swift
//  AuthModule
//
//  Created by Ameya on 03/12/25.
//

import AppModels

public enum UserAuthenticationState {
    case authenticated(userSession: UserSession)
    case unAuthenticated
}
