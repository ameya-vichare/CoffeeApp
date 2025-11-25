//
//  MenuListCoordinator.swift
//  Coffee App
//
//  Created by Ameya on 23/11/25.
//

import SwiftUI
import CoffeeModule
import AppModels

protocol MenuListCoordinatorDependencyDelegate: AnyObject {
    func makeMenuListView(navigationDelegate: MenuListViewNavigationDelegate) -> AnyView
    func makeMenuModifierBottomSheetView(for item: MenuItem, onOrderItemCreated: @escaping ((CreateOrderItem) -> Void)) -> AnyView
}

final class MenuListCoordinator: Coordinator, MenuListViewNavigationDelegate {
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
        let menuListView = UIHostingController(
            rootView: self.dependencyDelegate.makeMenuListView(navigationDelegate: self)
        )
        self.navigationController.pushViewController(menuListView, animated: true)
    }
    
    @MainActor
    func showMenuModifierBottomsheet(
        for item: MenuItem,
        onOrderItemCreated: @escaping ((CreateOrderItem) -> Void)
    ) {
        let sheetView = self.dependencyDelegate
            .makeMenuModifierBottomSheetView(for: item, onOrderItemCreated: onOrderItemCreated)
        
        let host = UIHostingController(rootView: sheetView)
        host.modalPresentationStyle = .pageSheet
        if let sheet = host.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }

        navigationController.present(host, animated: true)
    }
}
