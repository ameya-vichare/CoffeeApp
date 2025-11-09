//
//  AlertData.swift
//  DesignSystem
//
//  Created by Ameya on 02/11/25.
//

import Foundation

public struct AlertData: Identifiable {
    public let id: UUID = UUID()
    public let title: String
    public let message: String
    public let button: (text: String, action: (() -> Void)?)
    
    public init(
        title: String,
        message: String,
        button: (text: String, action: (() -> Void)?)
    ) {
        self.title = title
        self.message = message
        self.button = button
    }
}
