//
//  ImageService.swift
//  ImageLoading
//
//  Created by Ameya on 18/10/25.
//

import UIKit

public protocol ImageService: Sendable {
    func loadImage(with url: URL, options: ImageLoadingOptions) async throws -> UIImage
}
