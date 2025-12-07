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
import Resolver

final class OrderListDIContainer {
    @Injected private var networkService: NetworkService
    @Injected private var persistentProvider: PersistentContainerProvider
    @Injected private var imageService: ImageService
    
    init() {}
    
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
    func makeOrderListView(navigationDelegate: OrderListNavigationDelegate) -> AnyView {
        func getOrderModuleClientRepository() -> OrderModuleClientRepository {
            OrderModuleClientRepository(
                remoteAPI: OrderModuleRemoteAPI(
                    networkService: networkService
                ),
                dataStore: OrderModuleCoreDataStore(
                    container: persistentProvider.container
                )
            )
        }
        
        func makeCoffeeListViewModel() -> DefaultOrderListViewModel {
            DefaultOrderListViewModel(
                getOrdersUseCase: GetOrdersUseCase(
                    repository: getOrderModuleClientRepository()
                ),
                navigationDelegate: navigationDelegate
            )
        }
        
        let orderListView = OrderListView(viewModel: makeCoffeeListViewModel())
            .environment(\.imageService, imageService)
        
        return AnyView(orderListView)
    }
    
    func makeOrderDetailView() -> AnyView {
        let orderDetailView = OrderDetailView()
        return AnyView(orderDetailView)
    }
}
