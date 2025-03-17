// Created for graffiti_pics in 2025

import UIKit

final class RunningImageCache: ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    
    func image(for key: String) -> UIImage? {
        cache.object(forKey: NSString(string: key))
    }
    
    func save(image: UIImage, for key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
