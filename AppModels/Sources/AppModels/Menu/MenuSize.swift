//
//  MenuSize.swift
//  AppModels
//
//  Created by Ameya on 24/10/25.
//


import Foundation

public struct MenuSize: Decodable {
    let id: Int?
    let code: String?
    let label: String?
    let price: Float?
    let currency: String?
    
    public init(id: Int?, code: String?, label: String?, price: Float?, currency: String?) {
        self.id = id
        self.code = code
        self.label = label
        self.price = price
        self.currency = currency
    }
}
