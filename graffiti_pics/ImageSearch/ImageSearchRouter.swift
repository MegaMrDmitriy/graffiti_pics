// Created for graffiti_pics in 2025

import UIKit

struct ImageSearchRouter {
    enum Route {
        case imagePreview(images: [String], initialIndex: Int)
    }
    
    var navigationController: UINavigationController?
    
    func navigate(to route: Route) {
        switch route {
        case .imagePreview(let images, let initialIndex):
            let previewImagesViewController = ImagePreviewBuilder().build(images: images, initialIndex: initialIndex)
            navigationController?.pushViewController(previewImagesViewController, animated: true)
        }
    }
}
