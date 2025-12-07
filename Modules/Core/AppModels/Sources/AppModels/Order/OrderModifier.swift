//
//  OrderModifier.swift
//  AppModels
//
//  Created by Ameya on 24/10/25.
//


public struct OrderModifier: Decodable {
    public let group: String?
    public let name: String?
    
    public init(group: String?, name: String?) {
        self.group = group
        self.name = name
    }
}
