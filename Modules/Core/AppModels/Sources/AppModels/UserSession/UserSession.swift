//
//  UserSession.swift
//  AppModels
//
//  Created by Ameya on 01/12/25.
//

public struct UserSession: Codable {
    let userId: String
    let userName: String
    let token: String
    
    public init(userId: String, userName: String, token: String) {
        self.userId = userId
        self.userName = userName
        self.token = token
    }
}
