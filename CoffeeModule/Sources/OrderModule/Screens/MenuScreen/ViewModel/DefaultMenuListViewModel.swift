//
//  MenuListViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 24/10/25.
//

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
    public let networkMonitor: NetworkMonitoring
    
    public let getMenuUseCase: GetMenuUsecaseProtocol
    public let createOrderUseCase: CreateOrderUsecaseProtocol
    public let retryPendingOrdersUsecase: RetryPendingOrdersUsecaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Output
    @Published private(set) var state: ScreenViewState = .preparing
    @Published private(set) var datasource: [MenuListCellType] = []
    
    private(set) var orderItemUpdates = PassthroughSubject<CreateOrderItem, Never>()
    private(set) var alertPublisher = PassthroughSubject<AlertData?, Never>()
    
    // MARK: - Init
    public init(
        networkMonitor: NetworkMonitoring,
        getMenuUseCase: GetMenuUsecaseProtocol,
        createOrderUseCase: CreateOrderUsecaseProtocol,
        retryPendingOrdersUsecase: RetryPendingOrdersUsecaseProtocol
    ) {
        self.networkMonitor = networkMonitor
        self.getMenuUseCase = getMenuUseCase
        self.createOrderUseCase = createOrderUseCase
        self.retryPendingOrdersUsecase = retryPendingOrdersUsecase
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
            try await self.retryPendingOrdersUsecase.execute()
            self.showAlert(title: "Order Retry Success", message: "We have sent your previously failed order!")
        } catch let error as OrderModuleUsecaseError {
            self.showAlert(title: error.title, message: error.message)
        } catch {}
    }
    
    private func createOrder(orderItem: CreateOrderItem) async {
        do {
            try await self.createOrderUseCase.execute(using: orderItem)
            self.showAlert(title: "Order Success", message: "Your order has been placed!")
        } catch let error as OrderModuleUsecaseError {
            self.showAlert(title: error.title, message: error.message)
        } catch {}
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
    
    private func prepareDatasource(using response: MenuResponse?) {
        guard let menuItems = response?.menu else { return }
        
        self.datasource = menuItems.compactMap { menuItem in
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
        do {
            self.state = .fetchingData
            let response = try await self.getMenuUseCase.execute()
            self.prepareDatasource(using: response)
            self.state = .dataFetched
        } catch {
            
        }
    }
}
