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

struct CoffeeListCellItem: Identifiable {
    let id: Int
    let type: CoffeeListCellType
}

enum CoffeeListCellType {
    case coffeeOrder(vm: CoffeeCellViewModel)
}

final class CoffeeListViewModel: ObservableObject {
    private let repository: CoffeeModuleRepository
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    @Published var datasource: [CoffeeListCellItem] = []
    
    init(repository: CoffeeModuleRepository) {
        self.repository = repository
    }
}

extension CoffeeListViewModel {
    func makeInitialAPICalls() {
        let getCoffeeOrderConfig = CoffeeOrderEndpoint.getOrders
        self.repository.getCoffeeOrders(config: getCoffeeOrderConfig)
            .receive(on: DispatchQueue.main)
            .sink { error in
                print(error)
            } receiveValue: { [weak self] coffeeList in
                self?.prepareDatasource(coffeeList: coffeeList)
            }
            .store(in: &cancellables)
    }
    
    private func prepareDatasource(coffeeList: [Coffee]) {
        self.datasource = coffeeList.map { coffee in
            CoffeeListCellItem(
                id: coffee.id ?? 0,
                type: CoffeeListCellType.coffeeOrder(
                    vm: CoffeeCellViewModel(
                        id: coffee.id ?? 0,
                        userName: coffee.userName ?? "",
                        coffeeType: coffee.type?.rawValue ?? "",
                        coffeeSize: coffee.size?.description ?? "",
                        coffeeExtras: coffee.extras ?? "",
                        coffeeStatus: coffee.status?.rawValue ?? "",
                        coffeeImageURL: coffee.type?.imageURL ?? "",
                        createdAt: coffee.createdAt ?? ""
                    )
                )
            )
        }
    }
}
