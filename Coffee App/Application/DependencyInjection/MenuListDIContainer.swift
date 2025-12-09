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
    @Injected private var networkMonitoringService: NetworkMonitoring
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
        func makeMenuListViewModel() -> DefaultMenuListViewModel {
            DefaultMenuListViewModel(
                networkMonitor: networkMonitoringService,
                getMenuUseCase: Resolver.resolve(GetMenuUsecase.self),
                createOrderUseCase: Resolver.resolve(CreateOrderUsecase.self),
                retryPendingOrdersUsecase: Resolver.resolve(RetryPendingOrdersUsecase.self),
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
                priceComputeUseCase: Resolver.resolve(MenuModifierBottomSheetPriceComputeUsecase.self),
                createOrderUseCase: Resolver.resolve(MenuModifierBottomSheetCreateOrderUseCase.self)
            )
        ).environment(\.imageService, imageService)
        
        return AnyView(sheetView)
    }
}
