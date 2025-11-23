//
//  OrderListCoordinator.swift
//  Coffee App
//
//  Created by Ameya on 23/11/25.
//

import SwiftUI
import CoffeeModule

protocol OrderListCoordinatorDependencyDelegate {
    func makeOrderListView() -> AnyView
}

final class OrderListCoordinator: Coordinator {
    let navigationController: UINavigationController
    let dependencyDelegate: OrderListCoordinatorDependencyDelegate
    
    init(navigationController: UINavigationController, dependencyDelegate: OrderListCoordinatorDependencyDelegate) {
        self.navigationController = navigationController
        self.dependencyDelegate = dependencyDelegate
    }

    func start() {
        let orderListView = UIHostingController(rootView: self.dependencyDelegate.makeOrderListView())
        self.navigationController.pushViewController(orderListView, animated: true)
    }
}
