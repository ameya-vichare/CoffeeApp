//
//  SwiftUIImageLoader.swift
//  ImageLoading
//
//  Created by Ameya on 18/10/25.
//

import UIKit

@MainActor
public final class SwiftUIImageLoader: ObservableObject {
    @Published public var image: UIImage?
    @Published public var isLoading: Bool = false
    private let imageService: ImageService
    
    public init(imageService: ImageService) {
        self.imageService = imageService
    }
    
    func loadImage(with url: URL, preferredSize: CGSize?, scale: CGFloat = UIScreen.main.scale) async {
        var _preferredSize: CGSize?
        if let preferredSize {
            _preferredSize = CGSize(width: preferredSize.width * scale, height: preferredSize.height * scale)
        }
        
        let imageLoadingOptions: ImageLoadingOptions = ImageLoadingOptions(preferredSize: _preferredSize)
        self.isLoading = true
        
        do {
            let image = try await imageService.loadImage(with: url, options: imageLoadingOptions)
            self.image = image
            self.isLoading = false
        } catch {
            self.isLoading = false
        }
    }
}
