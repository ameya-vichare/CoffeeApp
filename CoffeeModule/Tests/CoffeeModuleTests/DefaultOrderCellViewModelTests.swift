//
//  DefaultOrderCellViewModelTests.swift
//  CoffeeModule
//
//  Created by Ameya on 13/11/25.
//

import XCTest
import AppModels
@testable import CoffeeModule

final class OrderCellViewModelTests: XCTestCase {
    
    var sut: OrderCellViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testOrderCellViewModel_WhenAllDataIsValid_ThenDataIsMappedCorrectly() {
        // Given
        let order = Order.createFake()
        sut = OrderCellViewModel(
            order: order,
            itemsViewModel: [
                OrderItemCellViewModel(
                    item: OrderItem.createFake()
                )
            ]
        )
        
        // When
        
        // Then
        XCTAssertEqual(sut.id, "1", "OrderCellViewModel's id should be mapped correctly")
        XCTAssertEqual(sut.userName, "Ameya", "OrderCellViewModel's id should be mapped correctly")
        XCTAssertEqual(sut.displayTotalPriceLabel, "USD 12", "OrderCellViewModel's displayTotalPriceLabel should be mapped correctly")
        XCTAssertEqual(sut.statusDisplayLabel, "pending", "OrderCellViewModel's statusDisplayLabel should be mapped correctly")
        XCTAssertEqual(sut.itemsViewModel.count, 1, "OrderCellViewModel's itemsViewModel should be mapped correctly")
        XCTAssertEqual(sut.createdAt, "Thu, Nov 13 | 2:43 pm")
    }
    
    func testOrderCellViewModel_WhenAllDataIsInvalid_ThenDataIsMappedToEmpty() {
        // Given
        let order = Order(
            id: nil,
            createdAt: nil,
            userName: nil,
            currency: nil,
            totalPrice: nil,
            status: nil,
            items: []
        )
        sut = OrderCellViewModel(
            order: order,
            itemsViewModel: []
        )
        
        // When
        
        // Then
        XCTAssertEqual(sut.id, "", "OrderCellViewModel's id should be mapped correctly")
        XCTAssertEqual(sut.userName, "", "OrderCellViewModel's id should be mapped correctly")
        XCTAssertEqual(sut.displayTotalPriceLabel, "", "OrderCellViewModel's displayTotalPriceLabel should be mapped correctly")
        XCTAssertEqual(sut.statusDisplayLabel, "", "OrderCellViewModel's statusDisplayLabel should be mapped correctly")
        XCTAssertEqual(sut.itemsViewModel.count, 0, "OrderCellViewModel's itemsViewModel should be mapped correctly")
        XCTAssertEqual(sut.createdAt, "")
    }
    
    func testOrderCellViewModel_WhenCurrencyIsNotAvailableAndTotalPriceIsAvailable_ThenTotalPriceIsShownInCorrectFormat() {
        let order = Order(
            id: nil,
            createdAt: nil,
            userName: nil,
            currency: nil,
            totalPrice: "12",
            status: nil,
            items: []
        )
        sut = OrderCellViewModel(
            order: order,
            itemsViewModel: []
        )
        
        XCTAssertEqual(sut.displayTotalPriceLabel, "", "OrderCellViewModel's displayTotalPriceLabel should be mapped correctly")
    }
    
    func testOrderCellViewModel_WhenCurrencyIsAvailableAndTotalPriceIsNotAvailable_ThenTotalPriceIsShownInCorrectFormat() {
        let order = Order(
            id: nil,
            createdAt: nil,
            userName: nil,
            currency: "$",
            totalPrice: nil,
            status: nil,
            items: []
        )
        sut = OrderCellViewModel(
            order: order,
            itemsViewModel: []
        )
        
        XCTAssertEqual(sut.displayTotalPriceLabel, "", "OrderCellViewModel's displayTotalPriceLabel should be mapped correctly")
    }

}
