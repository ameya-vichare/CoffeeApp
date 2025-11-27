//
//  OrderListViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import SwiftUI
import AppModels
import Networking
import DesignSystem
import Combine

public protocol OrderListNavigationDelegate {
    func navigateToOrderDetail(orderID: String)
}

protocol OrderListViewModelOutput {
    var datasource: [OrderListCellType] { get }
    var state: ScreenViewState { get }
    var alertPublisher: AnyPublisher<AlertData?, Never> { get }
}

protocol OrderListViewModelInput {
    func viewDidLoad() async
    func didRefresh() async
}

typealias OrderListViewModel = OrderListViewModelInput & OrderListViewModelOutput

@MainActor
public final class DefaultOrderListViewModel: ObservableObject, OrderListViewModel {
    public let getOrdersUseCase: GetOrdersUseCaseProtocol
    
    let navigationDelegate: OrderListNavigationDelegate?
    
    // MARK: - Output
    @Published var datasource: [OrderListCellType] = []
    @Published var state: ScreenViewState = .preparing
    
    private(set) var alertSubject = PassthroughSubject<AlertData?, Never>()
    var alertPublisher: AnyPublisher<AlertData?, Never> {
        self.alertSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    public init(
        getOrdersUseCase: GetOrdersUseCaseProtocol,
        navigationDelegate: OrderListNavigationDelegate?
    ) {
        self.getOrdersUseCase = getOrdersUseCase
        self.navigationDelegate = navigationDelegate
    }
}

// MARK: - Input
extension DefaultOrderListViewModel {
    func viewDidLoad() async {
        await self.getOrders()
    }
    
    func didRefresh() async {
        await self.getOrders()
    }

    private func getOrders() async {
        self.resetDatasource()
        self.state = .fetchingData

        do {
            let orders = try await self.getOrdersUseCase.execute()
            self.prepareDatasource(orders: orders)
            self.state = .dataFetched
        } catch let error as NetworkError {
            self.state = .error
            self.showAlert(title: error.title, message: error.message)
        } catch {
            self.state = .error
        }
    }
}

// MARK: - Output
extension DefaultOrderListViewModel {
    private func prepareDatasource(orders: [Order]) {
        self.datasource = orders.compactMap { order in
            guard let orderID = order.id,
                  !orderID.isEmpty else {
                return nil
            }
            
            func getItemsVM(items: [OrderItem]) -> [OrderItemCellViewModel] {
                items.map { OrderItemCellViewModel(item: $0) }
            }
            
            func getOrderVM(order: Order, itemsVM: [OrderItemCellViewModel]) -> OrderCellViewModel {
                let onNavigateToOrderDetail: (String) -> Void = { [weak self] orderId in
                    guard let self else { return }
                    self.navigationDelegate?.navigateToOrderDetail(orderID: orderId)
                }
                
                return DefaultOrderCellViewModel(
                    order: order,
                    itemsViewModel: itemsVM,
                    onNavigateToOrderDetail: onNavigateToOrderDetail
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
    
    private func resetDatasource() {
        self.datasource = []
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
