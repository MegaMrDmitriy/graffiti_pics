// Created for graffiti_pics in 2025

import UIKit

protocol ImageCache: AnyObject {
    func image(for key: String) -> UIImage?
    func save(image: UIImage, for key: String)
    
    func clearCache()
}
