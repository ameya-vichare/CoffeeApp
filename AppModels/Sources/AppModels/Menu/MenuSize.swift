//
//  MenuSize.swift
//  AppModels
//
//  Created by Ameya on 24/10/25.
//


import Foundation

public struct MenuSize: Decodable {
    public let id: Int?
    public let code: String?
    public let label: String?
    public let price: Double?
    public let currency: String?
    
    public init(id: Int?, code: String?, label: String?, price: Double?, currency: String?) {
        self.id = id
        self.code = code
        self.label = label
        self.price = price
        self.currency = currency
    }
}
