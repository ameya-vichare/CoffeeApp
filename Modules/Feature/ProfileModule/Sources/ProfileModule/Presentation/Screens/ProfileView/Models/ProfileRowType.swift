//
//  ProfileRowType.swift
//  ProfileModule
//
//  Created by Ameya on 29/12/25.
//

import Foundation

public enum ProfileRowType: Identifiable {
    public var id: String {
        self.name
    }
    
    case settings
    case myOrders
    case address
    case changePassword
    case helpAndSupport
    case logout
    
    public var name: String {
        switch self {
        case .settings: return "Settings"
        case .myOrders: return "My Orders"
        case .address: return "Address"
        case .changePassword: return "Change Password"
        case .helpAndSupport: return "Help & Support"
        case .logout: return "Logout"
        }
    }
    
    public var imageName: String {
        switch self {
        case .settings: return "gearshape"
        case .myOrders: return "list.bullet"
        case .address: return "mappin.and.ellipse"
        case .changePassword: return "lock"
        case .helpAndSupport: return "questionmark.circle"
        case .logout: return "arrow.right.square"
        }
    }
}

