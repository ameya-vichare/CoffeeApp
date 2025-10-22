//
//  CoffeeListViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import SwiftUI
import AppEndpoints
import AppModels

struct CoffeeListCellItem: Identifiable, Equatable {
    let id: String
    let type: CoffeeListCellType
    
    static func == (lhs: CoffeeListCellItem, rhs: CoffeeListCellItem) -> Bool {
        lhs.id == rhs.id
    }
}

enum CoffeeListCellType {
    case coffeeOrder(vm: OrderCellViewModel)
}

enum CoffeeListViewState {
    case preparing
    case fetchingData
    case dataFetched
    case error
}

public final class CoffeeListViewModel: ObservableObject {
    public let repository: CoffeeModuleRepository
    @Published var datasource: [CoffeeListCellItem] = []
    @Published var state: CoffeeListViewState = .preparing
    
    public init(repository: CoffeeModuleRepository) {
        self.repository = repository
    }
}

extension CoffeeListViewModel {
    @MainActor
    func makeInitialAPICalls() async {
        self.resetDatasource()
        self.state = .fetchingData
        let getCoffeeOrderConfig = CoffeeOrderEndpoint.getOrders
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
                items.map { item in
                    OrderItemCellViewModel(
                        name: item.name ?? "",
                        size: item.size ?? "",
                        modifiers: item.modifier.compactMap{ $0.name },
                        imageURL: item.imageURL ?? "",
                        totalPrice: item.totalPrice ?? "",
                        currency: item.currency ?? "",
                        quantity: item.quantity ?? ""
                    )
                }
            }
            
            func getOrderVM(order: Order, itemsVM: [OrderItemCellViewModel]) -> OrderCellViewModel {
                OrderCellViewModel(
                    id: orderID,
                    userName: order.userName ?? "",
                    createdAt: order.createdAt ?? "",
                    totalPrice: order.totalPrice ?? "",
                    currency: order.currency ?? "",
                    status: order.status?.description ?? "",
                    items: itemsVM
                )
            }

            return CoffeeListCellItem(
                id: orderID,
                type: CoffeeListCellType.coffeeOrder(
                    vm: getOrderVM(
                        order: order,
                        itemsVM: getItemsVM(items: order.items)
                    )
                )
            )
        }
    }
}

