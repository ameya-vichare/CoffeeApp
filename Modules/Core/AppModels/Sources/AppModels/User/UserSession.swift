//
//  UserSession.swift
//  AppModels
//
//  Created by Ameya on 01/12/25.
//

public struct UserSession: Codable {
    public let userId: Int
    public let userName: String
    public let token: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userName = "user_name"
        case token
    }
    
    public init(userId: Int, userName: String, token: String) {
        self.userId = userId
        self.userName = userName
        self.token = token
    }
}
