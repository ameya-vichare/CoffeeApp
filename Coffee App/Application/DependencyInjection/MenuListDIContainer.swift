//
//  MenuListDIContainer.swift
//  Coffee App
//
//  Created by Ameya on 23/11/25.
//

import CoffeeModule
import Persistence
import Networking
import NetworkMonitoring
import SwiftUI
import ImageLoading
import Combine
import AppModels

final class MenuListDIContainer: MenuListCoordinatorDependencyDelegate {
    struct Dependencies {
        let networkService: NetworkService
        let networkMonitoringService: NetworkMonitoring
        let persistentProvider: PersistentContainerProvider
        let imageService: ImageService
    }
    
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    @MainActor
    func makeMenuListView(navigationDelegate: MenuListViewNavigationDelegate) -> AnyView {
        func makeMenuListViewModel() -> DefaultMenuListViewModel {
            let orderModuleClientRepository = getOrderModuleClientRepository()
            return DefaultMenuListViewModel(
                networkMonitor: self.dependencies.networkMonitoringService,
                getMenuUseCase: GetMenuUsecase(
                    repository: orderModuleClientRepository
                ),
                createOrderUseCase: CreateOrderUsecase(
                    repository: orderModuleClientRepository,
                    networkMonitor: self.dependencies.networkMonitoringService
                ),
                retryPendingOrdersUsecase: RetryPendingOrdersUsecase(
                    repository: orderModuleClientRepository
                ),
                navigationDelegate: navigationDelegate
            )
        }
        
        let menuListView = MenuListView(viewModel: makeMenuListViewModel())
            .environment(\.imageService, self.dependencies.imageService)
        
        return AnyView(menuListView)
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
    
    func makeMenuListCoordinator(navigationController: UINavigationController) -> MenuListCoordinator {
        MenuListCoordinator(
            navigationController: navigationController,
            dependencyDelegate: self
        )
    }
    
    @MainActor
    func makeMenuModifierBottomSheetView(for item: MenuItem, onOrderItemCreated: @escaping ((CreateOrderItem) -> Void)) -> AnyView {
        let sheetView = MenuModifierBottomSheet(
            viewModel: DefaultMenuModifierBottomSheetViewModel(
                menuItem: item,
                onOrderItemCreated: onOrderItemCreated,
                priceComputeUseCase: MenuModifierBottomSheetPriceComputeUsecase(),
                createOrderUseCase: MenuModifierBottomSheetCreateOrderUseCase()
            )
        )
        
        return AnyView(sheetView)
    }
}

