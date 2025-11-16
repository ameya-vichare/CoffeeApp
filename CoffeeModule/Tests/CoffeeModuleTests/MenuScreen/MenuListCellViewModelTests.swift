//
//  MenuListCellViewModelTests.swift
//  CoffeeModule
//
//  Created by Ameya on 16/11/25.
//

import XCTest
import Combine
import AppModels
@testable import CoffeeModule

final class MenuListCellViewModelTests: XCTestCase {
    
    var sut: MenuListCellViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testMenuListCellViewModel_WhenGivenValidData_ThenMappingIsCorrect() {
        // Given
        sut = MenuListCellViewModel(
            menuItem: MenuItem.createFake(),
            orderItemUpdates: PassthroughSubject<CreateOrderItem, Never>()
        )

        // Then
        XCTAssertEqual(
            sut.id,
            8,
            "MenuListCellViewModel's id should be mapped correctly"
        )
        XCTAssertEqual(
            sut.name,
            "Hot Americano",
            "MenuListCellViewModel's name should be mapped correctly"
        )
        XCTAssertEqual(
            sut.currency,
            "USD",
            "MenuListCellViewModel's currency should be mapped correctly"
        )
        XCTAssertEqual(
            sut.price,
            14.00,
            "MenuListCellViewModel's price should be mapped correctly"
        )
        XCTAssertEqual(
            sut.displayPrice,
            "14",
            "MenuListCellViewModel's displayPrice should be formatted correctly"
        )
        XCTAssertEqual(
            sut.description,
            "A shot of espresso, diluted to create a smooth black coffee.",
            "MenuListCellViewModel's description should be formatted correctly"
        )
        XCTAssertEqual(
            sut.imageURL,
            URL(string: "https://images.unsplash.com/photo-1669872484166-e11b9638b50e"),
            "MenuListCellViewModel's imageURL should be formatted correctly"
        )
    }
    
    func testMenuListCellViewModel_WhenGivenInvalidData_ThenDefaultValuesAreMapped() {
        // Given
        sut = MenuListCellViewModel(
            menuItem: MenuItem(
                id: nil,
                name: nil,
                description: nil,
                imageURL: nil,
                basePrice: nil,
                currency: nil,
                modifiers: nil
            ),
            orderItemUpdates: PassthroughSubject<CreateOrderItem, Never>()
        )

        // Then
        XCTAssertEqual(
            sut.id,
            0,
            "MenuListCellViewModel's id should be mapped correctly"
        )
        XCTAssertEqual(
            sut.name,
            "",
            "MenuListCellViewModel's name should be mapped correctly"
        )
        XCTAssertEqual(
            sut.currency,
            "",
            "MenuListCellViewModel's currency should be mapped correctly"
        )
        XCTAssertEqual(
            sut.price,
            0.0,
            "MenuListCellViewModel's price should be mapped correctly"
        )
        XCTAssertEqual(
            sut.displayPrice,
            "0",
            "MenuListCellViewModel's displayPrice should be mapped correctly"
        )
        XCTAssertEqual(
            sut.description,
            "",
            "MenuListCellViewModel's description should be mapped correctly"
        )
        XCTAssertEqual(
            sut.imageURL,
            URL(string: ""),
            "MenuListCellViewModel's imageURL should be mapped correctly"
        )
    }
}
