//
//  CreateOrderItem.swift
//  AppModels
//
//  Created by Ameya on 02/11/25.
//

public struct CreateOrderItem: Codable, Sendable {
    public let itemID: Int
    public let quantity: Int
    public let optionIDs: [Int]
    
    enum CodingKeys: String, CodingKey {
        case itemID = "item_id"
        case quantity
        case optionIDs = "option_ids"
    }
    
    public init(itemID: Int, quantity: Int, optionIDs: [Int]) {
        self.itemID = itemID
        self.quantity = quantity
        self.optionIDs = optionIDs
    }
}
