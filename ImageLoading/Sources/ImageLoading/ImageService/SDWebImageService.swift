//
//  SDWebImageService.swift
//  ImageLoading
//
//  Created by Ameya on 18/10/25.
//

import SDWebImage

public final class SDWebImageService: ImageService {
    public init() {}
    
    public func loadImage(with url: URL, options: ImageLoadingOptions) async throws -> UIImage {
        let imageManager = SDWebImageManager.shared
        
        var context: [SDWebImageContextOption: Any] = [:]
        if let preferredSize = options.preferredSize {
            context[.imageTransformer] = SDImageResizingTransformer(size: preferredSize, scaleMode: .aspectFill)
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            imageManager.loadImage(
                with: url,
                context: context,
                progress: nil) { image, data, error, imageCache, completed, url in
                    if let error {
                        return continuation.resume(throwing: error)
                    } else if let image {
                        return continuation.resume(with: .success(image))
                    }
                }
        }
    }
}
