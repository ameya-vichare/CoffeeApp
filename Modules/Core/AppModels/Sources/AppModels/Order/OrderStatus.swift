//
//  OrderStatus.swift
//  AppModels
//
//  Created by Ameya on 24/10/25.
//

public enum OrderStatus: String, Decodable {
    case pending = "pending"
    case inProgress = "in_progress"
    
    public var description: String {
        switch self {
        case .pending:
            return "Pending"
        case .inProgress:
            return "In Progress"
        }
    }
}
