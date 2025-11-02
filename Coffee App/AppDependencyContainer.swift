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

@MainActor
final class AppDependencyContainer {
    private let networkService: NetworkService
    private let imageService: ImageService
    
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
    }
    
    func getImageService() -> ImageService {
        imageService
    }
}

// MARK: - Coffee List View
extension AppDependencyContainer {
    func makeCoffeeListView() -> OrderListView {
        func makeCoffeeListViewModel() -> OrderListViewModel {
            OrderListViewModel(
                repository: CoffeeModuleClientRepository(
                    remoteAPI: OrderModuleRemoteAPI(
                        networkService: networkService
                    )
                )
            )
        }
        
        return OrderListView(viewModel: makeCoffeeListViewModel())
    }
}

// MARK: - Coffee Order View
extension AppDependencyContainer {
    func makeCoffeeOrderView() -> MenuListView {
        func makeMenuListViewModel() -> MenuListViewModel {
            MenuListViewModel(
                repository: CoffeeModuleClientRepository(
                    remoteAPI: OrderModuleRemoteAPI(
                        networkService: networkService
                    )
                )
            )
        }
        
        return MenuListView(viewModel: makeMenuListViewModel())
    }
}

