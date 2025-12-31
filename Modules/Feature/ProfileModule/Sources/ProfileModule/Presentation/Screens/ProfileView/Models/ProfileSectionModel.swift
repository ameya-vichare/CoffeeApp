//
//  ProfileSectionModel.swift
//  ProfileModule
//
//  Created by Ameya on 29/12/25.
//

import Foundation

public struct ProfileSectionModel: Identifiable {
    public let id = UUID()
    public let rows: [ProfileRowType]
    
    public init(rows: [ProfileRowType]) {
        self.rows = rows
    }
}

