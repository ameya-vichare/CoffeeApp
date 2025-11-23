//
//  OrderListCoordinator.swift
//  Coffee App
//
//  Created by Ameya on 22/11/25.
//

import SwiftUI
import CoffeeModule

protocol OrderListCoordinatorDependencies {
    func makeOrderListView() -> OrderListView
}

final class OrderListCoordinator: Coordinator {
    let navigationController: UINavigationController
    let dependencies: OrderListCoordinatorDependencies

    init(navigationController: UINavigationController, dependencies: OrderListCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let orderListView = UIHostingController(rootView: self.dependencies.makeOrderListView())
        self.navigationController.pushViewController(orderListView, animated: true)
    }
}
