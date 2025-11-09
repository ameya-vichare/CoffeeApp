//
//  MenuListViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 24/10/25.
//

import Foundation
import AppEndpoints
import Networking
import AppModels
import Combine
import DesignSystem
import SwiftUI
import NetworkMonitoring

protocol MenuListViewModelOutput {
    var state: ScreenViewState { get }
    var datasource: [MenuListCellType] { get }
    
    var orderItemUpdates: PassthroughSubject<CreateOrderItem, Never> { get }
    var alertPublisher: PassthroughSubject<AlertData?, Never> { get }
}

protocol MenuListViewModelInput {
    func viewDidLoad() async
}

typealias MenuListViewModel = MenuListViewModelInput & MenuListViewModelOutput

@MainActor
public final class DefaultMenuListViewModel: ObservableObject, MenuListViewModel {
    public let repository: OrderModuleRepositoryProtocol
    public let networkMonitor: NetworkMonitoring
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Output
    @Published private(set) var state: ScreenViewState = .preparing
    @Published private(set) var datasource: [MenuListCellType] = []
    
    private(set) var orderItemUpdates = PassthroughSubject<CreateOrderItem, Never>()
    private(set) var alertPublisher = PassthroughSubject<AlertData?, Never>()
    
    // MARK: - Init
    public init(repository: OrderModuleRepositoryProtocol, networkMonitor: NetworkMonitoring) {
        self.repository = repository
        self.networkMonitor = networkMonitor
        self.bindChildren()
    }
    
    // MARK: - Private
    private func bindChildren() {
        self.orderItemUpdates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] orderItem in
                guard let self else { return }
                Task {
                    await self.createOrder(orderItem: orderItem)
                }
            }
            .store(in: &cancellables)
        
        self.networkMonitor.monitoringPublisher
            .removeDuplicates()
            .debounce(
                for: .milliseconds(1000),
                scheduler: DispatchQueue.main
            )
            .sink { [weak self] networkStatus in
                print("Received network status: \(networkStatus)")
                guard let self, networkStatus == .available else {
                    return
                }
                Task {
                    await self.retryPendingOrders()
                }
            }
            .store(in: &cancellables)
    }
    
    private func retryPendingOrders() async {
        do {
            try await self.repository.retryPendingOrders()
            self.showAlert(title: "Order Retry Success", message: "We have sent your previously failed order!")
        } catch {
            if let error = error as? OrderRepositoryError,
               error != .noPendingOrders {
                self.showAlert(title: "Order Retry Failed", message: "We couldn't send your previously failed order.")
            }
        }
    }
    
    private func createOrder(orderItem: CreateOrderItem) async {
        let orderData = CreateOrder(userId: 1, items: [orderItem])
        let createOrderAPIConfig = CreateOrderEndpoint.createOrder(data: orderData)
        
        do {
            guard networkMonitor.status == .available else {
                try await self.repository.storeCreateOrder(order: orderData)
                self.showAlert(title: "Order Failed", message: "We couldn't send your order, but we will retry!")
                return
            }
            
            let response = try await self.repository.createOrder(config: createOrderAPIConfig)
            self.showAlert(title: "Order Success", message: "Your order has been placed!")
        } catch {
            self.state = .error
            self.showAlert(title: "Order Failed", message: "We couldn't send your order, but we will retry!")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = AlertData(
            title: title,
            message: message,
            buttons: [
                Alert.Button.default(Text("Vooho!"), action: {
                    self.alertPublisher.send(nil)
                })
            ]
        )
        self.alertPublisher.send(alert)
    }
    
    private func prepareDatasource(menuList: [MenuItem]) {
        self.datasource = menuList.compactMap { menuItem in
            return .mainMenu(
                vm: MenuListCellViewModel(
                    menuItem: menuItem,
                    orderItemUpdates: orderItemUpdates
                )
            )
        }
    }
}

// MARK: - Input
extension DefaultMenuListViewModel {
    func viewDidLoad() async {
        let getMenuAPIConfig = MenuEndpoint.getMenuItems
        self.state = .fetchingData
    
        do {
            let response = try await self.repository.getMenu(
                config: getMenuAPIConfig
            )
            if let menuList = response.menu {
                self.prepareDatasource(menuList: menuList)
                self.state = .dataFetched
            } else {
                self.state = .error
            }
        } catch {
            self.state = .error
        }
    }
}
