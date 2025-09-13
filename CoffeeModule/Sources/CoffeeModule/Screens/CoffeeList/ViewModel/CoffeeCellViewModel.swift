//
//  CoffeeCellViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import AppUtils
import Foundation

final class CoffeeCellViewModel {
    let id: Int
    let userName: String
    let coffeeType: String
    let coffeeSize: String
    let coffeeExtras: String
    let coffeeStatus: String
    let coffeeImageURL: URL?
    let createdAt: String
    
    init(
        id: Int,
        userName: String,
        coffeeType: String,
        coffeeSize: String,
        coffeeExtras: String,
        coffeeStatus: String,
        coffeeImageURL: String,
        createdAt: String
    ) {
        self.id = id
        self.userName = userName
        self.coffeeType = coffeeType
        self.coffeeSize = coffeeSize
        self.coffeeExtras = coffeeExtras
        self.coffeeStatus = coffeeStatus.capitalized
        self.coffeeImageURL = URL(string: coffeeImageURL)
        
        if let createdAt = createdAt.formatDate(dateFormat: DateFormat.shortDate) {
            self.createdAt = createdAt
        } else {
            self.createdAt = ""
        }
    }
}
