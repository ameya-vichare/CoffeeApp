//
//  ImageServiceEnvironmentKeys.swift
//  ImageLoading
//
//  Created by Ameya on 18/10/25.
//

import SwiftUI

private struct ImageServiceKey: EnvironmentKey {
    static public let defaultValue: ImageService = SDWebImageService()
}

extension EnvironmentValues {
    public var imageService: ImageService {
        get {
            self[ImageServiceKey.self]
        } set {
            self[ImageServiceKey.self] = newValue
        }
    }
}
