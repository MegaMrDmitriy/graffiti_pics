// Created for graffiti_pics in 2025

import Foundation

final class ImagePreviewViewModel {
    let images: [ImagePreviewModel]
    private(set) var currentIndex: Int
    
    let imageProvider: ImageProvider
    
    var imageCount: Int {
        images.count
    }
    
    var positionText: String {
        "\(currentIndex + 1)/\(imageCount)"
    }
    
    init(
        images: [ImagePreviewModel],
        initialIndex: Int,
        imageProvider: ImageProvider
    ) {
        self.images = images
        self.currentIndex = initialIndex
        self.imageProvider = imageProvider
    }
    
    func updateCurrentIndex(_ index: Int) {
        currentIndex = index
    }
}
