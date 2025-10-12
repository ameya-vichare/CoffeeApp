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

public protocol ImageService: Sendable {
    func loadImage(with url: URL, options: ImageLoadingOptions) async throws -> UIImage
}

public final class SDWebImageService: ImageService {
    public init () {}
    
    public func loadImage(with url: URL, options: ImageLoadingOptions) async throws -> UIImage {
        let imageManager = SDWebImageManager.shared
        var downloadToken: SDWebImageCombinedOperation?
        
        var context: [SDWebImageContextOption: Any] = [:]
        if let preferredSize = options.preferredSize {
            let imageTransformer = SDImageResizingTransformer(size: preferredSize, scaleMode: .aspectFill)
            context[.imageTransformer] = imageTransformer
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            imageManager.loadImage(
                with: url,
                context: context,
                progress: nil) { image, data, error, cacheType, completed, url in
                    if let error {
                        continuation.resume(throwing: error)
                    }
                    
                    if let image {
                        continuation.resume(with: .success(image))
                    }
                }
        }
        
//        return Deferred {
//            Future<UIImage, Error> { promise in
//                downloadToken = imageManager.loadImage(
//                    with: url,
//                    context: context,
//                    progress: nil) { image, data, error, cacheType, completed, url in
//                        if let error {
//                            promise(.failure(error))
//                        }
//                        
//                        if let image {
//                            promise(.success(image))
//                        }
//                    }
//            }
//        }
//        .handleEvents(receiveCancel: {
//            downloadToken?.cancel()
//        }).eraseToAnyPublisher()
    }
}

@MainActor
public final class SwiftUIImageLoader: ObservableObject {
    @Published private(set) var image: UIImage?
    @Published private(set) var isLoading: Bool?
    
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
            let image = try await self.imageService.loadImage(with: url, options: options)
            self.isLoading = false
            self.image = image
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
