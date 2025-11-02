//
//  CreateOrderItem.swift
//  AppModels
//
//  Created by Ameya on 02/11/25.
//

public struct CreateOrderItem: Codable {
    let itemID: Int
    let quantity: Int
    let optionIDs: [Int]
    
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
