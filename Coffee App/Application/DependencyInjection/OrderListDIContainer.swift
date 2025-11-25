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

final class OrderListDIContainer {
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
}

// MARK: - Coordinator dependencies implementation
extension OrderListDIContainer: OrderListCoordinatorDependencyDelegate {
    @MainActor
    func makeOrderListView() -> AnyView {
        func getOrderModuleClientRepository() -> OrderModuleClientRepository {
            OrderModuleClientRepository(
                remoteAPI: OrderModuleRemoteAPI(
                    networkService: self.dependencies.networkService
                ),
                dataStore: OrderModuleCoreDataStore(
                    container: self.dependencies.persistentProvider.container
                )
            )
        }
        
        func makeCoffeeListViewModel() -> DefaultOrderListViewModel {
            DefaultOrderListViewModel(
                getOrdersUseCase: GetOrdersUseCase(
                    repository: getOrderModuleClientRepository()
                )
            )
        }
        
        let orderListView = OrderListView(viewModel: makeCoffeeListViewModel())
            .environment(\.imageService, self.dependencies.imageService)
        
        return AnyView(orderListView)
    }
}
