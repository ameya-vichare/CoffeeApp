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
import AppCore
import Resolver

final class MenuListDIContainer {
    @Injected private var networkService: NetworkService
    @Injected private var networkMonitoringService: NetworkMonitoring
    @Injected private var persistentProvider: PersistentContainerProvider
    @Injected private var imageService: ImageService
    
    init() {}
    
    func makeMenuListCoordinator(navigationController: UINavigationController) -> MenuListCoordinator {
        MenuListCoordinator(
            navigationController: navigationController,
            dependencyDelegate: self
        )
    }
}

// MARK: - Coordinator dependencies implementation
extension MenuListDIContainer: MenuListCoordinatorDependencyDelegate {
    @MainActor
    func makeMenuListView(navigationDelegate: MenuListViewNavigationDelegate) -> AnyView {
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
                navigationDelegate: navigationDelegate
            )
        }
        
        let menuListView = MenuListView(viewModel: makeMenuListViewModel())
            .environment(\.imageService, imageService)
        
        return AnyView(menuListView)
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
        ).environment(\.imageService, imageService)
        
        return AnyView(sheetView)
    }
}
