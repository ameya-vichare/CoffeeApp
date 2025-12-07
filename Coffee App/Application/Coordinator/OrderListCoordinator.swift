//
//  OrderListCoordinator.swift
//  Coffee App
//
//  Created by Ameya on 23/11/25.
//

import SwiftUI
import CoffeeModule
import AppCore

protocol OrderListCoordinatorDependencyDelegate {
    func makeOrderListView(navigationDelegate: OrderListNavigationDelegate) -> AnyView
    func makeOrderDetailView() -> AnyView
}

final class OrderListCoordinator: Coordinator {
    let navigationController: UINavigationController
    let dependencyDelegate: OrderListCoordinatorDependencyDelegate
    
    init(navigationController: UINavigationController, dependencyDelegate: OrderListCoordinatorDependencyDelegate) {
        self.navigationController = navigationController
        self.dependencyDelegate = dependencyDelegate
    }

    // MARK: - Initial navigation
    func start() {
        let orderListView = UIHostingController(
            rootView: self.dependencyDelegate
                .makeOrderListView(navigationDelegate: self)
        )
        self.navigationController.pushViewController(orderListView, animated: true)
    }
}

// MARK: - Container navigation implementation
extension OrderListCoordinator: OrderListNavigationDelegate {
    func navigateToOrderDetail(orderID: String) {
        let orderDetailView = UIHostingController(
            rootView: self.dependencyDelegate.makeOrderDetailView()
        )
        self.navigationController.pushViewController(orderDetailView, animated: true)
    }
}

