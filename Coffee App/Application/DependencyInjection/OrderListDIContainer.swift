//
//  OrderListDIContainer.swift
//  Coffee App
//
//  Created by Ameya on 22/11/25.
//

import CoffeeModule
import Persistence
import Networking
import UIKit

final class OrderListDIContainer: OrderListCoordinatorDependencies {
    private let networkService: NetworkService
    private let persistentProvider: PersistentContainerProvider
    
    init(networkService: NetworkService, persistentProvider: PersistentContainerProvider) {
        self.networkService = networkService
        self.persistentProvider = persistentProvider
    }

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
    
    func makeOrderListCoordinator(navigationController: UINavigationController) -> OrderListCoordinator {
        OrderListCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
