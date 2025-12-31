//
//  UserLogin.swift
//  AppModels
//
//  Created by Ameya on 05/12/25.
//

public struct UserLogin: Codable {
    public let userName: String
    public let password: String
    
    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case password
    }
    
    public init(userName: String, password: String) {
        self.userName = userName
        self.password = password
    }
}

