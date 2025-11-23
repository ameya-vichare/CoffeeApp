//
//  OrderListDIContainer.swift
//  Coffee App
//
//  Created by Ameya on 23/11/25.
//

import CoffeeModule
import Persistence
import Networking
import SwiftUI
import ImageLoading

final class OrderListDIContainer: OrderListCoordinatorDependencyDelegate {
    struct Dependencies {
        let networkService: NetworkService
        let persistentProvider: PersistentContainerProvider
        let imageService: ImageService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeOrderListCoordinator(navigationController: UINavigationController) -> OrderListCoordinator {
        OrderListCoordinator(
            navigationController: navigationController,
            dependencyDelegate: self
        )
    }
    
    @MainActor
    func makeOrderListView() -> AnyView {
        let orderModuleClientRepository = getOrderModuleClientRepository()
        func makeCoffeeListViewModel() -> DefaultOrderListViewModel {
            DefaultOrderListViewModel(
                getOrdersUseCase: GetOrdersUseCase(
                    repository: orderModuleClientRepository
                )
            )
        }
        
        let orderListView = OrderListView(viewModel: makeCoffeeListViewModel())
            .environment(\.imageService, self.dependencies.imageService)
        
        return AnyView(orderListView)
    }
    
    private func getOrderModuleClientRepository() -> OrderModuleClientRepository {
        OrderModuleClientRepository(
            remoteAPI: OrderModuleRemoteAPI(
                networkService: self.dependencies.networkService
            ),
            dataStore: OrderModuleCoreDataStore(
                container: self.dependencies.persistentProvider.container
            )
        )
    }
}
