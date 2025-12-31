//
//  AppDependencyContainer.swift
//  Coffee App
//
//  Created by Ameya on 10/10/25.
//

import Networking
import NetworkMonitoring
import AppCore
import Foundation
import CoffeeModule
import ImageLoading
import SwiftUI
import Persistence
import AuthModule
import Resolver

final class AppDIContainer {
    @Injected private var networkService: NetworkService
    @Injected private var networkMonitoringService: NetworkMonitoring
    
    // Shared
    @Injected private var sharedAuthRepository: AuthRepositoryProtocol
    private var sharedUserSession: UserSession?
    
    init() {
        self.networkService.set(headerProvider: self)
        self.networkMonitoringService.start()
    }
}

// MARK: - Container creation
extension AppDIContainer: TabBarCoordinatorDependencyDelegate {
    func makeOrderListDIContainer() -> OrderListDIContainer {
        OrderListDIContainer()
    }
    
    func makeMenuListDIContainer() -> MenuListDIContainer {
        MenuListDIContainer()
    }
}

extension AppDIContainer {
    func makeTabBarCoordinator(navigationController: UINavigationController) -> TabBarCoordinator {
        TabBarCoordinator(
            navigationController: navigationController,
            dependencyDelegate: self
        )
    }
    
    func makeAuthDIContainer() -> AuthDIContainer {
        AuthDIContainer(
            dependencies: AuthDIContainer.Dependencies(
                makeTabBarCoordinator: makeTabBarCoordinator(navigationController:),
                updateUserSession: updateUserSession(_:)
            )
        )
    }
    
    func makeProfileDIContainer() -> ProfileDIContainer {
        ProfileDIContainer(
            dependencies: ProfileDIContainer.Dependencies(
                onUserLogoutSuccess: { [weak self] in
                    self?.onUserLogoutSuccess()
                    self?.showLogin()
                }
            )
        )
    }
}

// MARK: - User Session
extension AppDIContainer {
    @discardableResult
    func getUserAuthState() async -> UserAuthenticationState {
        do {
            let userSession = try await self.sharedAuthRepository.getUserSession()
            self.updateUserSession(userSession)
            return .authenticated(userSession: userSession)
        } catch {
            return .unAuthenticated
        }
    }
    
    func updateUserSession(_ userSession: UserSession?) {
        self.sharedUserSession = userSession
    }
    
    func onUserLogoutSuccess() {
        self.updateUserSession(nil)
        
    }
    
    private func showLogin() {
        // Get the root navigation controller from the window
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
              let navigationController = window.rootViewController as? UINavigationController else {
            return
        }
        
        // Clear the navigation stack and show login
        let authDIContainer = makeAuthDIContainer()
        let authCoordinator = authDIContainer.makeAuthCoordinator(
            navigationController: navigationController
        )
        navigationController.setViewControllers([], animated: false)
        authCoordinator.start()
    }
}

// MARK: - Header Provider
extension AppDIContainer: NetworkServiceHeaderProvider {
    func getDynamicHeaders() -> [String : String] {
        var headers: [String: String] = [:]
        
        if let token = sharedUserSession?.token {
            headers["token"] = token
        }
        
        return headers
    }
}
