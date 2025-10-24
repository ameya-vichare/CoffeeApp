//
//  Menu.swift
//  AppModels
//
//  Created by Ameya on 24/10/25.
//

import Foundation

public struct Menu: Decodable {
    let menu: [MenuItem]?
    
    public init(menu: [MenuItem]?) {
        self.menu = menu
    }
}
