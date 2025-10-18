// The Swift Programming Language
// https://docs.swift.org/swift-book

import SDWebImage
import SwiftUI

public struct ImageLoadingOptions {
    let preferredSize: CGSize?
    
    public init(preferredSize: CGSize?) {
        self.preferredSize = preferredSize
    }
}

public protocol ImageLoadCancellable: Sendable {
    func cancel()
}

public final class SDWebImageLoadCanceller: @unchecked Sendable, ImageLoadCancellable {
    private let token: SDWebImageCombinedOperation
    
    public init(token: SDWebImageCombinedOperation) {
        self.token = token
    }
    
    public func cancel() {
        token.cancel()
    }
}

public protocol ImageService: Sendable {
    func loadImage(with url: URL, options: ImageLoadingOptions) async throws -> ImageLoadResult
}

public struct ImageLoadResult: Sendable {
    public let image: UIImage
    public let cancellable: ImageLoadCancellable
}

public final class SDWebImageService: ImageService {
    public init () {}
    
    public func loadImage(with url: URL, options: ImageLoadingOptions) async throws -> ImageLoadResult {
        let imageManager = SDWebImageManager.shared
        var downloadToken: SDWebImageCombinedOperation?
        
        var context: [SDWebImageContextOption: Any] = [:]
        if let preferredSize = options.preferredSize {
            let imageTransformer = SDImageResizingTransformer(size: preferredSize, scaleMode: .aspectFill)
            context[.imageTransformer] = imageTransformer
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            downloadToken = imageManager.loadImage(
                with: url,
                context: context,
                progress: nil) { image, data, error, cacheType, completed, url in
                    if let error {
                        continuation.resume(throwing: error)
                    } else if let image, let downloadToken {
                        let cancellable = SDWebImageLoadCanceller(token: downloadToken)
                        let imageLoadResult = ImageLoadResult(image: image, cancellable: cancellable)
                        continuation.resume(with: .success(imageLoadResult))
                    }
                }
        }
    }
}

@MainActor
public final class SwiftUIImageLoader: ObservableObject {
    @Published private(set) var image: UIImage?
    @Published private(set) var isLoading: Bool?
    private var cancellable: ImageLoadCancellable?
    
    let imageService: ImageService
    
    public init(imageService: ImageService) {
        self.imageService = imageService
    }
    
    func loadImage(url: URL, targetSize: CGSize?, scale: CGFloat = UIScreen.main.scale) async {
        self.reset()
        
        var preferredSize: CGSize?
        if let targetSize {
            preferredSize = CGSize(width: round(targetSize.width * scale), height: round(targetSize.height * scale))
        }
    
        let options: ImageLoadingOptions = ImageLoadingOptions(preferredSize: preferredSize)
        
        self.isLoading = true
        
        do {
            let result = try await self.imageService.loadImage(with: url, options: options)
            self.isLoading = false
            self.image = result.image
            self.cancellable = result.cancellable
        }
        catch {
            print(error)
            self.isLoading = false
        }
    }
    
    private func reset() {
        self.image = nil
        self.isLoading = nil
    }
    
    func cancel() {
//        cancellables.forEach { $0.cancel() }
//        cancellables.removeAll()
    }
}

public struct CustomImageView<Placeholder: View>: View {
    private let url: URL?
    private let targetSize: CGSize?
    @StateObject private var loader: SwiftUIImageLoader
    private let placeholder: Placeholder
    
    public init(
        url: URL?,
        targetSize: CGSize? = nil,
        imageService: ImageService = SDWebImageService(),
        @ViewBuilder placeholder: () -> Placeholder
    ) {
        self.url = url
        self.targetSize = targetSize
        self.placeholder = placeholder()
        self._loader = StateObject(wrappedValue: SwiftUIImageLoader(imageService: imageService))
    }

    public var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            }
            else if let isLoading = loader.isLoading, isLoading {
                placeholder
            } else {
                placeholder
            }
        }
        .task {
            if let url {
                do {
                    try await loader.loadImage(url: url, targetSize: targetSize)
                }
                catch {
                    print("Error loading image: \(error)")
                }
            }
        }
    }
}

private struct ImageServiceKey: EnvironmentKey {
    static let defaultValue: ImageService = SDWebImageService()
}

public extension EnvironmentValues {
    var imageService: ImageService {
        get {
            self[ImageServiceKey.self]
        } set {
            self[ImageServiceKey.self] = newValue
        }
    }
}
