//
//  TabBarCoordinator.swift
//  Coffee App
//
//  Created by Ameya on 23/11/25.
//

import UIKit

protocol TabBarCoordinatorDependencyDelegate {
    func makeOrderListDIContainer() -> OrderListDIContainer
    func makeMenuListDIContainer() -> MenuListDIContainer
}

final class TabBarCoordinator: Coordinator {
    let navigationController: UINavigationController
    let dependencyDelegate: TabBarCoordinatorDependencyDelegate
    
    private let tabBarController = UITabBarController()
    
    init(navigationController: UINavigationController, dependencyDelegate: TabBarCoordinatorDependencyDelegate) {
        self.navigationController = navigationController
        self.dependencyDelegate = dependencyDelegate
    }

    // MARK: - Initial navigation
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
        
        let orderListDIContainer = self.dependencyDelegate.makeOrderListDIContainer()
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
        
        let menuListDIContainer = self.dependencyDelegate.makeMenuListDIContainer()
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
