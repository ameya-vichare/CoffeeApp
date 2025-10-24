//
//  MenuModifier.swift
//  AppModels
//
//  Created by Ameya on 24/10/25.
//

import Foundation

public struct MenuModifier: Decodable {
    public let id: Int?
    public let name: String?
    public let selectionType: String?
    public let minSelect: Int?
    public let maxSelect: Int?
    public let options: [MenuModifierOption]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case selectionType = "selection_type"
        case minSelect = "min_select"
        case maxSelect = "max_select"
        case options
    }
    
    public init(id: Int?, name: String?, selectionType: String?, minSelect: Int?, maxSelect: Int?, options: [MenuModifierOption]?) {
        self.id = id
        self.name = name
        self.selectionType = selectionType
        self.minSelect = minSelect
        self.maxSelect = maxSelect
        self.options = options
    }
}
