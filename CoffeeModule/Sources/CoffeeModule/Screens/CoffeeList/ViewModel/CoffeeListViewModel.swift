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
    func makeInitialAPICalls() async {
        self.resetDatasource()
        self.state = .fetchingData
        let getCoffeeOrderConfig = CoffeeOrderEndpoint.getOrders
        
        do {
            let orders = try await self.repository.getCoffeeOrders(config: getCoffeeOrderConfig)
            self.prepareDatasource(coffeeList: orders)
            self.state = .dataFetched
        }
        catch {
            print(error)
        }
    }
    
    private func resetDatasource() {
        self.datasource = []
    }
    
    private func prepareDatasource(coffeeList: [Order]) {
        self.datasource = coffeeList.map { order in
            CoffeeListCellItem(
                id: order.id ?? "1",
                type: CoffeeListCellType.coffeeOrder(
                    vm: OrderCellViewModel(
                        id: order.id ?? "1",
                        userName: order.userName ?? "",
                        createdAt: order.createdAt ?? "",
                        totalPrice: order.totalPrice ?? "",
                        currency: order.currency ?? "",
                        status: order.status?.description ?? "",
                        items: order.items.map { item in
                            OrderItemCellViewModel(
                                name: item.name ?? "",
                                size: item.size ?? "",
                                modifiers: item.modifier.flatMap{ $0.name },
                                imageURL: item.imageURL ?? "",
                                totalPrice: item.totalPrice ?? "",
                                currency: item.currency ?? "",
                                quantity: item.quantity ?? ""
                            )
                        }
                    )
                )
            )
        }
    }
}
