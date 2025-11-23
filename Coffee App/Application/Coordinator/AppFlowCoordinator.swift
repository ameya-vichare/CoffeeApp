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
        let orderListNavController = UINavigationController()
        let orderListDIContainer = dependencyContainer.makeOrderListDIContainer()
        let orderListCoordinator = orderListDIContainer.makeOrderListCoordinator(
            navigationController: orderListNavController
        )
        orderListNavController.tabBarItem = UITabBarItem(
            title: "Orders",
            image: UIImage(systemName: "list.bullet"),
            selectedImage: nil
        )
        orderListCoordinator.start()
        
        let menuListNavController = UINavigationController()
        let menuListDIContainer = dependencyContainer.makeMenuListDIContainer()
        let menuListCoordinator = menuListDIContainer.makeMenuListCoordinator(
            navigationController: menuListNavController
        )
        menuListNavController.tabBarItem = UITabBarItem(
            title: "Menu",
            image: UIImage(systemName: "cup.and.saucer"),
            selectedImage: nil
        )
        menuListCoordinator.start()
        
        tabBarController.viewControllers = [
            orderListNavController,
            menuListNavController
        ]
        
        navigationController.setViewControllers([tabBarController], animated: false)
    }
}
