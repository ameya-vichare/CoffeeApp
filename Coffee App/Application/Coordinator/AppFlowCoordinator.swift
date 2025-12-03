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

    // MARK: - Initial navigation
    func start() {
        Task {
            await checkAuthenticationAndRoute()
        }
    }
    
    @MainActor
    private func checkAuthenticationAndRoute() async {
        let authState = await self.dependencyContainer.getUserAuthState()
        
        switch authState {
        case .authenticated(_):
            showHome()
        case .unAuthenticated:
            showLogin()
        }
    }
    
    private func showHome() {
        let tabBarCoordinator = dependencyContainer.makeTabBarCoordinator(
            navigationController: navigationController
        )
        tabBarCoordinator.start()
    }
    
    private func showLogin() {
        print("Login")
    }
}
