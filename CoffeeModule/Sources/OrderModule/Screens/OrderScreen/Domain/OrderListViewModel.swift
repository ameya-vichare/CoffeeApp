//
//  OrderListViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import SwiftUI
import AppEndpoints
import AppModels
import Networking
import DesignSystem
import Combine

protocol OrderListViewModelOutput {
    var datasource: [OrderListCellType] { get }
    var state: ScreenViewState { get }
}

protocol OrderListViewModelInput {
    func viewDidLoad()
}

//typealias OrderListViewModel = OrderListViewModelInput & OrderListViewModelOutput

public final class OrderListViewModel: ObservableObject {
    public let repository: OrderModuleRepositoryProtocol
    @Published var datasource: [OrderListCellType] = []
    @Published var state: ScreenViewState = .preparing
    
    private(set) var alertSubject = PassthroughSubject<AlertData?, Never>()
    var alertPublisher: AnyPublisher<AlertData?, Never> {
        self.alertSubject.eraseToAnyPublisher()
    }
    
    public init(repository: OrderModuleRepositoryProtocol) {
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
                let orders = try await _repository.getOrders(config: getCoffeeOrderConfig)
                self.prepareDatasource(coffeeList: orders)
                self.state = .dataFetched
            } catch let error as NetworkError {
                self.state = .error
                self.showAlert(title: error.title, message: error.message)
            } catch {
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
    
    private func showAlert(title: String, message: String) {
        let alert = AlertData(
            title: title,
            message: message,
            button: (text: "Okay", action: { [weak self] in
                self?.alertSubject.send(nil)
            })
        )
        self.alertSubject.send(alert)
    }
}

