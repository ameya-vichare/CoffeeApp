//
//  AppDependencyContainer.swift
//  Coffee App
//
//  Created by Ameya on 10/10/25.
//

import Networking
import NetworkMonitoring
import AppConstants
import Foundation
import CoffeeModule
import ImageLoading
import SwiftUI
import Persistence

final class AppDIContainer {
    private let networkService: NetworkService
    private let imageService: ImageService
    private let persistentProvider: PersistentContainerProvider
    private let networkMonitoringService: NetworkMonitoring
    
    init() {
        let appConfiguration = AppConfiguration()
        guard let url = URL(string: appConfiguration.apiBaseURL) else {
            fatalError("Invalid URL: \(appConfiguration.apiBaseURL)")
        }
        
        self.networkService = NetworkClient(
            baseURL: url,
            defaultHeaders: [
                "Authorization": "Bearer \(appConfiguration.apiKey)"
            ]
        )
        
        self.imageService = SDWebImageService()
        
        self.persistentProvider = PersistentContainerProvider(modelName: "AppModel")
        
        self.networkMonitoringService = NetworkMonitor()
        self.networkMonitoringService.start()
    }
    
    func getImageService() -> ImageService {
        imageService
    }
}

// MARK: - Container creation
extension AppDIContainer: TabBarCoordinatorDependencyDelegate {
    func makeTabBarCoordinator(navigationController: UINavigationController) -> TabBarCoordinator {
        TabBarCoordinator(
            navigationController: navigationController,
            dependencyDelegate: self
        )
    }
    
    func makeOrderListDIContainer() -> OrderListDIContainer {
        OrderListDIContainer(
            dependencies: OrderListDIContainer.Dependencies(
                networkService: networkService,
                persistentProvider: persistentProvider,
                imageService: imageService
            )
        )
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
