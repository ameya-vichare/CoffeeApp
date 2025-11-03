//
//  AlertData.swift
//  DesignSystem
//
//  Created by Ameya on 02/11/25.
//

import SwiftUI

public struct AlertData: Identifiable {
    public let id: UUID = UUID()
    public let title: String
    public let message: String
    public let buttons: [Alert.Button]
    
    public init(
        title: String,
        message: String,
        buttons: [Alert.Button] = [.default(Text("OK"))]
    ) {
        self.title = title
        self.message = message
        self.buttons = buttons
    }
}
