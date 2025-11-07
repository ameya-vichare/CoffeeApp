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

@MainActor
public final class MenuListViewModel: ObservableObject {
    public let repository: OrderModuleRepositoryProtocol
    @Published var state: ScreenViewState = .preparing
    @Published var datasource: [MenuListCellType] = []
    
    private var orderItemUpdates = PassthroughSubject<CreateOrderItem, Never>()
    private(set) var alertPublisher = PassthroughSubject<AlertData?, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    public init(repository: OrderModuleRepositoryProtocol) {
        self.repository = repository
        self.bindChildren()
    }
}

extension MenuListViewModel {
    func makeInitialAPICalls() async {
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
    }
    
    private func createOrder(orderItem: CreateOrderItem) async {
        let orderData = CreateOrder(userId: 1, items: [orderItem])
        let createOrderAPIConfig = CreateOrderEndpoint.createOrder(data: orderData)
        
        do {
            let response = try await self.repository.createOrder(
                config: createOrderAPIConfig
            )
            self.showSuccessAlert()
        } catch {
            self.state = .error
        }
    }
    
    private func showSuccessAlert() {
        let alert = AlertData(
            title: "Order Success",
            message: "Your order has been placed!",
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
