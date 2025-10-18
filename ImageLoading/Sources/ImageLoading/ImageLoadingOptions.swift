//
//  ImageLoadingOptions.swift
//  ImageLoading
//
//  Created by Ameya on 18/10/25.
//

import Foundation

public struct ImageLoadingOptions {
    let preferredSize: CGSize?
    
    public init(preferredSize: CGSize?) {
        self.preferredSize = preferredSize
    }
}
