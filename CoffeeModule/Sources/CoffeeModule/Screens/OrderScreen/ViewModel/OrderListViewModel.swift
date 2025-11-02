//
//  OrderListViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import SwiftUI
import AppEndpoints
import AppModels

public final class OrderListViewModel: ObservableObject {
    public let repository: CoffeeModuleRepository
    @Published var datasource: [OrderListCellType] = []
    @Published var state: ScreenViewState = .preparing
    
    public init(repository: CoffeeModuleRepository) {
        self.repository = repository
    }
}

extension OrderListViewModel {
    @MainActor
    func makeInitialAPICalls() async {
        self.resetDatasource()
        self.state = .fetchingData
        let getCoffeeOrderConfig = OrderEndpoint.getOrders
        let _repository = self.repository
        
        Task {
            do {
                let orders = try await _repository.getCoffeeOrders(config: getCoffeeOrderConfig)
                self.prepareDatasource(coffeeList: orders)
                self.state = .dataFetched
            }
            catch {
                self.state = .error
            }
        }
    }
    
    private func resetDatasource() {
        self.datasource = []
    }
    
    private func prepareDatasource(coffeeList: [Order]) {
        self.datasource = coffeeList.compactMap { order in
            guard let orderID = order.id,
                  !orderID.isEmpty else {
                return nil
            }
            
            func getItemsVM(items: [OrderItem]) -> [OrderItemCellViewModel] {
                items.map { OrderItemCellViewModel(item: $0) }
            }
            
            func getOrderVM(order: Order, itemsVM: [OrderItemCellViewModel]) -> OrderCellViewModel {
                OrderCellViewModel(
                    order: order,
                    itemsViewModel: itemsVM
                )
            }

            return OrderListCellType.coffeeOrder(
                vm: getOrderVM(
                    order: order,
                    itemsVM: getItemsVM(items: order.items)
                )
            )
        }
    }
}

