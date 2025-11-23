//
//  AppFlowCoordinator.swift
//  Coffee App
//
//  Created by Ameya on 22/11/25.
//

import SwiftUI

//            NavigationStack {
//                appDependencyContainer.makeMenuListView()
//            }
//            .tabItem {
//                Label("Order", systemImage: "cup.and.saucer")
//            }

final class AppFlowCoordinator: Coordinator {
    let container: AppDIContainer
    let navigationController: UINavigationController
    let tabBarController = UITabBarController()
    
    init(container: AppDIContainer, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }
    
    func start() {
        let orderListNavVC = UINavigationController()
        let orderListDIContainer = self.container.makeOrderListDIContainer()
        let orderListCoordinator = orderListDIContainer.makeOrderListCoordinator(navigationController: orderListNavVC)
        orderListCoordinator.start()
        orderListNavVC.tabBarItem = UITabBarItem(
            title: "List",
            image: UIImage(systemName: "list.bullet"),
            tag: 0
        )
        tabBarController.viewControllers = [orderListNavVC]
        navigationController.pushViewController(tabBarController, animated: true)
    }
}
