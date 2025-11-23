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
    
    init(navigationController: UINavigationController, dependencyContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }

    func start() {
        let tabBarCoordinator = dependencyContainer.makeTabBarCoordinator(
            navigationController: navigationController
        )
        tabBarCoordinator.start()
    }
}
