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
        func makeCoffeeListViewModel() -> DefaultOrderListViewModel {
            DefaultOrderListViewModel(
                getOrdersUseCase: Resolver.resolve(GetOrdersUseCase.self),
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
