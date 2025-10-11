//
//  CoffeeListViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import SwiftUI
import AppEndpoints
import Combine
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
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    @Published var datasource: [CoffeeListCellItem] = []
    @Published var state: CoffeeListViewState = .preparing
    
    public init(repository: CoffeeModuleRepository) {
        self.repository = repository
    }
}

extension CoffeeListViewModel {
    func makeInitialAPICalls() {
        self.resetDatasource()
        self.state = .fetchingData
        let getCoffeeOrderConfig = CoffeeOrderEndpoint.getOrders
        self.repository.getCoffeeOrders(config: getCoffeeOrderConfig)
            .receive(on: DispatchQueue.main)
            .sink { error in
                print(error)
            } receiveValue: { [weak self] coffeeList in
                print(coffeeList)
                self?.prepareDatasource(coffeeList: coffeeList)
                self?.state = .dataFetched
            }
            .store(in: &cancellables)
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
                        items: order.items.map { item in
                            OrderItemCellViewModel(
                                name: item.name ?? "",
                                size: item.size ?? "",
                                extras: "",
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
