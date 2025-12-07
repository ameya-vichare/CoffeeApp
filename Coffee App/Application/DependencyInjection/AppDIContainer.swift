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

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        let assembly: [DependencyAssembly] = [
            CoreServicesAssembly()
        ]
        
        assembly.forEach { $0.assemble(using: main) }
    }
}

final class AppDIContainer {
    @Injected private var networkService: NetworkService
    @Injected private var imageService: ImageService
    @Injected private var persistentProvider: PersistentContainerProvider
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
        MenuListDIContainer(
            dependencies: MenuListDIContainer.Dependencies(
                networkService: networkService,
                networkMonitoringService: networkMonitoringService,
                persistentProvider: persistentProvider,
                imageService: imageService
            )
        )
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
    
    func updateUserSession(_ userSession: UserSession) {
        self.sharedUserSession = userSession
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
