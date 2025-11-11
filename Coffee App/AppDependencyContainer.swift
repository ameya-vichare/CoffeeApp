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

final class AppDependencyContainer {
    private let networkService: NetworkService
    private let imageService: ImageService
    private let persistentProvider: PersistentContainerProvider
    private let networkMonitoringService: NetworkMonitoring
    
    init() {
        guard let url = URL(string: AppConstants.baseURL) else {
            fatalError("Invalid URL: \(AppConstants.baseURL)")
        }
        
        self.networkService = NetworkClient(
            baseURL: url,
            defaultHeaders: [
                "Authorization": "Bearer \(AppConstants.apiKey)"
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

// MARK: - Order Module Views
extension AppDependencyContainer {
    @MainActor
    func makeOrderListView() -> OrderListView {
        let orderModuleClientRepository = getOrderModuleClientRepository()
        func makeCoffeeListViewModel() -> DefaultOrderListViewModel {
            DefaultOrderListViewModel(
                getOrdersUseCase: GetOrdersUseCase(
                    repository: orderModuleClientRepository
                )
            )
        }
        
        return OrderListView(viewModel: makeCoffeeListViewModel())
    }
    
    @MainActor
    func makeMenuListView() -> MenuListView {
        func makeMenuListViewModel() -> DefaultMenuListViewModel {
            let orderModuleClientRepository = getOrderModuleClientRepository()
            return DefaultMenuListViewModel(
                networkMonitor: networkMonitoringService,
                getMenuUseCase: GetMenuUsecase(
                    repository: orderModuleClientRepository
                ),
                createOrderUseCase: CreateOrderUsecase(
                    repository: orderModuleClientRepository,
                    networkMonitor: networkMonitoringService
                ),
                retryPendingOrdersUsecase: RetryPendingOrdersUsecase(
                    repository: orderModuleClientRepository
                ),
            )
        }
        
        return MenuListView(viewModel: makeMenuListViewModel())
    }
    
    private func getOrderModuleClientRepository() -> OrderModuleClientRepository {
        OrderModuleClientRepository(
            remoteAPI: OrderModuleRemoteAPI(
                networkService: networkService
            ),
            dataStore: OrderModuleCoreDataStore(
                container: persistentProvider.container
            )
        )
    }
}

