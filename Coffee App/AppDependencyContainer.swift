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

final class AppDependencyContainer {
    let networkService: NetworkService
    
    init() {
        guard let url = URL(string: AppConstants.baseURL) else {
            fatalError("Invalid URL: \(AppConstants.baseURL)")
        }
        
        self.networkService = NetworkClient(
            baseURL: url,
            defaultHeaders: [
                "apikey": AppConstants.apiKey
            ]
        )
    }
}

// MARK: - Coffee List View
extension AppDependencyContainer {
    func makeCoffeeListView() -> CoffeeListView {
        func makeCoffeeListViewModel() -> CoffeeListViewModel {
            CoffeeListViewModel(
                repository: CoffeeModuleClientRepository(
                    remoteAPI: CoffeeModuleRemoteAPI(
                        networkService: networkService
                    )
                )
            )
        }
        
        return CoffeeListView(viewModel: makeCoffeeListViewModel())
    }
}
