// Created for graffiti_pics in 2025

import UIKit

struct AppRouter {
    enum Route {
        case searchImages
    }
    
    var navigationController: UINavigationController?
    
    func navigate(to route: Route) {
        guard let navigationController else { return }
        
        switch route {
        case .searchImages:
            let searchImagesViewController = ImageSearchBuilder().build(navigationController: navigationController)
            navigationController.pushViewController(searchImagesViewController, animated: true)
        }
    }
}
