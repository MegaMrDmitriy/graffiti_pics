// Created for graffiti_pics in 2025

import UIKit

struct ImagePreviewBuilder {
    func build(
        images: [String],
        initialIndex: Int
    ) -> UIViewController {
        let factory = AppFactory.shared
        
        let imageProvider = factory.makeImageProvider()
        
        let viewModel = ImagePreviewViewModel(
            images: images.map({ ImagePreviewModel(imageURL: $0) }),
            initialIndex: initialIndex,
            imageProvider: imageProvider
        )
        let viewController = ImagePreviewViewController(viewModel: viewModel)
        return viewController
    }
}
