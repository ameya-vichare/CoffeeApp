//
//  AppDependencyContainer.swift
//  Coffee App
//
//  Created by Ameya on 10/10/25.
//

import Networking
import AppConstants
import Foundation
import CoffeeModule
import ImageLoading
import SwiftUI
import Persistence

@MainActor
final class AppDependencyContainer {
    private let networkService: NetworkService
    private let imageService: ImageService
    private let persistentProvider: PersistentContainerProvider
    
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
    }
    
    func getImageService() -> ImageService {
        imageService
    }
}

// MARK: - Coffee List View
extension AppDependencyContainer {
    func makeOrderListView() -> OrderListView {
        func makeCoffeeListViewModel() -> OrderListViewModel {
            OrderListViewModel(
                repository: OrderModuleClientRepository(
                    remoteAPI: OrderModuleRemoteAPI(
                        networkService: networkService
                    ),
                    dataStore: OrderModuleCoreDataStore(
                        container: persistentProvider.container
                    )
                )
            )
        }
        
        return OrderListView(viewModel: makeCoffeeListViewModel())
    }
}

// MARK: - Coffee Order View
extension AppDependencyContainer {
    func makeMenuListView() -> MenuListView {
        func makeMenuListViewModel() -> MenuListViewModel {
            MenuListViewModel(
                repository: OrderModuleClientRepository(
                    remoteAPI: OrderModuleRemoteAPI(
                        networkService: networkService
                    ),
                    dataStore: OrderModuleCoreDataStore(
                        container: persistentProvider.container
                    )
                )
            )
        }
        
        return MenuListView(viewModel: makeMenuListViewModel())
    }
}

