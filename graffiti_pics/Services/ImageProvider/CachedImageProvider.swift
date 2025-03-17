// Created for graffiti_pics in 2025

import UIKit

final actor CachedImageProvider: ImageProvider {
    private let imageCache: ImageCache
    
    init(
        imageCache: ImageCache
    ) {
        self.imageCache = imageCache
    }
    
    func image(for urlString: String) async throws -> UIImage {
        if let cachedImage = imageCache.image(for: urlString) {
            return cachedImage
        }
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        imageCache.save(image: image, for: urlString)
        return image
    }
}
