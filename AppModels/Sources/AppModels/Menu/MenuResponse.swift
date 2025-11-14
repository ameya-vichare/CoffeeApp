//
//  Menu.swift
//  AppModels
//
//  Created by Ameya on 24/10/25.
//

import Foundation

public struct MenuResponse: Decodable {
    public let menu: [MenuItem]?
    
    public init(menu: [MenuItem]?) {
        self.menu = menu
    }
    
    public static func createFake(menu: [MenuItem]? = [MenuItem.createFake()]) -> Self {
        MenuResponse(menu: menu)
    }
}
