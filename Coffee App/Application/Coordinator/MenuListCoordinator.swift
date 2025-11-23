//
//  MenuListCoordinator.swift
//  Coffee App
//
//  Created by Ameya on 23/11/25.
//

import SwiftUI
import CoffeeModule

protocol MenuListCoordinatorDependencyDelegate {
    func makeMenuListView() -> MenuListView
}

final class MenuListCoordinator: Coordinator {
    let navigationController: UINavigationController
    let dependencyDelegate: MenuListCoordinatorDependencyDelegate
    
    init(
        navigationController: UINavigationController,
        dependencyDelegate: MenuListCoordinatorDependencyDelegate
    ) {
        self.navigationController = navigationController
        self.dependencyDelegate = dependencyDelegate
    }

    func start() {
        let menuListView = UIHostingController(rootView: self.dependencyDelegate.makeMenuListView())
        self.navigationController.pushViewController(menuListView, animated: true)
    }
}
