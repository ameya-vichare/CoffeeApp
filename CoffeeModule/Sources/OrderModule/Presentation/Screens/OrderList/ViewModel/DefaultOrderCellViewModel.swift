//
//  OrderCellViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import AppUtils
import AppModels

protocol OrderCellViewModelOutput {
    var id: String { get }
    var userName: String { get }
    var createdAt: String { get }
    var displayTotalPriceLabel: String { get }
    var statusDisplayLabel: String { get }
    var itemsViewModel: [OrderItemCellViewModel] { get }
}

protocol OrderCellViewModelActions {
    func navigateToOrderDetail()
}

typealias OrderCellViewModel = OrderCellViewModelOutput & OrderCellViewModelActions

struct DefaultOrderCellViewModel: OrderCellViewModel {
    let id: String
    let userName: String
    let createdAt: String
    let displayTotalPriceLabel: String
    let statusDisplayLabel: String
    let itemsViewModel: [OrderItemCellViewModel]
    
    let onNavigateToOrderDetail: (String) -> Void
    
    init(
        order: Order,
        itemsViewModel: [OrderItemCellViewModel],
        onNavigateToOrderDetail: @escaping (String) -> Void
    ) {
        self.id = order.id ?? ""
        self.userName = order.userName ?? ""
        
        if let totalPrice = order.totalPrice, let currency = order.currency {
            self.displayTotalPriceLabel = "\(currency) \(totalPrice)"
        } else {
            self.displayTotalPriceLabel = ""
        }
        
        self.statusDisplayLabel = order.status?.rawValue ?? ""
        self.itemsViewModel = itemsViewModel
        
        if let createdAt = order.createdAt?.formatDate(dateFormat: DateFormat.shortDate) {
            self.createdAt = createdAt
        } else {
            self.createdAt = ""
        }
        
        self.onNavigateToOrderDetail = onNavigateToOrderDetail
    }
}

// MARK: - Actions
extension DefaultOrderCellViewModel {
    func navigateToOrderDetail() {
        onNavigateToOrderDetail(id)
    }
}
