//
//  AppFlowCoordinator.swift
//  Coffee App
//
//  Created by Ameya on 23/11/25.
//

import UIKit

final class AppFlowCoordinator: Coordinator {
    let navigationController: UINavigationController
    let dependencyContainer: AppDIContainer
    
    private let tabBarController = UITabBarController()
    
    init(navigationController: UINavigationController, dependencyContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }

    func start() {
        tabBarController.viewControllers = [
            setupOrderListTab(),
            setupMenuListTab()
        ]
        
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    private func setupOrderListTab() -> UINavigationController {
        let navigationController = UINavigationController()
        configure(
            navigationController: navigationController,
            withTitle: "Orders",
            andImageName: "list.bullet"
        )
        
        let orderListDIContainer = dependencyContainer.makeOrderListDIContainer()
        let orderListCoordinator = orderListDIContainer.makeOrderListCoordinator(
            navigationController: navigationController
        )
        orderListCoordinator.start()
        
        return navigationController
    }
    
    private func setupMenuListTab() -> UINavigationController {
        let navigationController = UINavigationController()
        configure(
            navigationController: navigationController,
            withTitle: "Menu",
            andImageName: "cup.and.saucer"
        )
        
        let menuListDIContainer = dependencyContainer.makeMenuListDIContainer()
        let menuListCoordinator = menuListDIContainer.makeMenuListCoordinator(
            navigationController: navigationController
        )
        menuListCoordinator.start()
        
        return navigationController
    }
    
    private func configure(
        navigationController: UINavigationController,
        withTitle title: String,
        andImageName imageName: String
    ) {
        navigationController.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: imageName),
            selectedImage: nil
        )
    }
}
