//
//  UserLogoutResponse.swift
//  AppModels
//
//  Created by Ameya on 31/12/25.
//

public struct UserLogoutResponse: Decodable {
    let success: Bool
    
    public init(success: Bool) {
        self.success = success
    }
}
