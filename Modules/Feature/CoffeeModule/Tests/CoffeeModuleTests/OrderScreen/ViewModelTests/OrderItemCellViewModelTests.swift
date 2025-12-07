//
//  OrderItemCellViewModelTests.swift
//  CoffeeModule
//
//  Created by Ameya on 13/11/25.
//

import XCTest
import AppCore
@testable import CoffeeModule

final class OrderItemCellViewModelTests: XCTestCase {
    
    var sut: OrderItemCellViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testOrderItemCellViewModel_WhenInitializedWithValidObject_ThenCorrectValuesAreSet() {
        sut = OrderItemCellViewModel(item: OrderItem.createFake())
        
        XCTAssertEqual(sut.name, "Hot Orange Zest Mocha", "OrderItemCellViewModel's name should be mapped correctly.")
        XCTAssertEqual(sut.customisation, "Small, Caramel", "OrderItemCellViewModel's customisation should be mapped correctly.")
        XCTAssertEqual(sut.imageURL, URL(string: "https://via.placeholder.com/150"), "OrderItemCellViewModel's imageURL should be mapped correctly.")
        XCTAssertEqual(sut.displayPriceLabel, "USD 12", "OrderItemCellViewModel's displayPriceLabel should be mapped correctly.")
        XCTAssertEqual(sut.displayQuantityLabel, "x1", "OrderItemCellViewModel's displayQuantityLabel should be mapped correctly.")
    }
    
    func testOrderItemCellViewModel_WhenInitializedWithInvalidObject_ThenEmptyValuesAreSet() {
        sut = OrderItemCellViewModel(
            item: OrderItem(
                name: nil,
                imageURL: nil,
                size: nil,
                quantity: nil,
                totalPrice: nil,
                currency: nil,
                modifier: []
            )
        )
        
        XCTAssertEqual(sut.name, "", "OrderItemCellViewModel's name should be mapped correctly.")
        XCTAssertEqual(sut.customisation, "", "OrderItemCellViewModel's customisation should be mapped correctly.")
        XCTAssertEqual(sut.imageURL, URL(string: ""), "OrderItemCellViewModel's imageURL should be mapped correctly.")
        XCTAssertEqual(sut.displayPriceLabel, "", "OrderItemCellViewModel's displayPriceLabel should be mapped correctly.")
        XCTAssertEqual(sut.displayQuantityLabel, "", "OrderItemCellViewModel's displayQuantityLabel should be mapped correctly.")
    }
    
    func testOrderItemCellViewModel_WhenCurrencyIsNil_ThenEmptyValuesAreSet() {
        sut = OrderItemCellViewModel(
            item: OrderItem(
                name: nil,
                imageURL: nil,
                size: nil,
                quantity: nil,
                totalPrice: "12",
                currency: nil,
                modifier: []
            )
        )
        
        XCTAssertEqual(sut.displayPriceLabel, "", "OrderItemCellViewModel's displayPriceLabel should be mapped correctly.")
    }
    
    func testOrderItemCellViewModel_WhenPriceIsNil_ThenEmptyValuesAreSet() {
        sut = OrderItemCellViewModel(
            item: OrderItem(
                name: nil,
                imageURL: nil,
                size: nil,
                quantity: nil,
                totalPrice: nil,
                currency: "$",
                modifier: []
            )
        )
        
        XCTAssertEqual(sut.displayPriceLabel, "", "OrderItemCellViewModel's displayPriceLabel should be mapped correctly.")
    }

}
