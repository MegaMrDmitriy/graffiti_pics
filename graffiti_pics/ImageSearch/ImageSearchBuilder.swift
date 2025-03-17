// Created for graffiti_pics in 2025

import UIKit
import PixabayAPI

struct ImageSearchBuilder {
    func build(navigationController: UINavigationController) -> UIViewController {
        let factory = AppFactory.shared
        
        let api = factory.makePixabayAPI()
        let imageProvider = factory.makeImageProvider()
        
        let router = ImageSearchRouter(navigationController: navigationController)
        let viewModel = ImageSearchViewModel(searchApi: api, imageProvider: imageProvider, router: router)
        let viewController = ImageSearchViewController(viewModel: viewModel)
        return viewController
    }
}
