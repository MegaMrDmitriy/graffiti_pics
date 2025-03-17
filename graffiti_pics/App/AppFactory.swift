// Created for graffiti_pics in 2025

import Foundation
import PixabayAPI

final class AppFactory {
    static let shared = AppFactory()
    
    private static let imageCache: ImageCache = RunningImageCache()
    
    func makeImageProvider() -> ImageProvider {
        CachedImageProvider(
            imageCache: Self.imageCache
        )
    }
    
    func makePixabayAPI() -> PixabayAPI {
        PixabayAPI(apiKey: "Place your key")
    }
}
