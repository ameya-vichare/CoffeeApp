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

    // MARK: - Initial navigation
    func start() {
        let menuListView = UIHostingController(
            rootView: self.dependencyDelegate.makeMenuListView(navigationDelegate: self)
        )
        self.navigationController.pushViewController(menuListView, animated: true)
    }
}

// MARK: - Navigation handling
extension MenuListCoordinator: MenuListViewNavigationDelegate {
    @MainActor
    func showMenuModifierBottomsheet(
        for item: MenuItem,
        onOrderItemCreated: @escaping ((CreateOrderItem) -> Void)
    ) {
        let sheetView = self.dependencyDelegate
            .makeMenuModifierBottomSheetView(for: item, onOrderItemCreated: onOrderItemCreated)
        
        let menuModifierSheet = UIHostingController(rootView: sheetView)
        menuModifierSheet.modalPresentationStyle = .pageSheet
        if let sheet = menuModifierSheet.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 10
        }

        navigationController.present(menuModifierSheet, animated: true)
    }
}
