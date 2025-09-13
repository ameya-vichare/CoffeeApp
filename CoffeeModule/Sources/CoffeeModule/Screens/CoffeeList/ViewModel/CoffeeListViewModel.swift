//
//  CoffeeListViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import SwiftUI
import AppEndpoints
import Combine

final class CoffeeListViewModel: ObservableObject {
    private let repository: CoffeeModuleRepository
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
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
            } receiveValue: { coffeeList in
                print(coffeeList)
            }
            .store(in: &cancellables)
    }
}
