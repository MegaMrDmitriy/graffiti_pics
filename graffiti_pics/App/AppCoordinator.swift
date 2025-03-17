// Created for graffiti_pics in 2025

import UIKit

final class AppCoordinator {
    
    private var router: AppRouter
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = UINavigationController()
        router = AppRouter(navigationController: navigationController)
        start()
    }
    
    func start() {
        router.navigate(to: .searchImages)
    }
}
