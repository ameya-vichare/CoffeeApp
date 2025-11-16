//
//  GetOrdersUseCaseTests.swift
//  CoffeeModule
//
//  Created by Ameya on 16/11/25.
//

import XCTest
import AppModels
import Networking
@testable import CoffeeModule

final class GetOrdersUseCaseTests: XCTestCase {
    
    var sut: GetOrdersUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testGetOrdersUseCase_WhenRepositoryReturnsSuccess_ReturnsOrders() async {
        // Given
        sut = GetOrdersUseCase(
            repository: FakeOrderModuleRepository(
                result: .getOrdersSuccess([Order.createFake()])
            )
        )
        
        var result: [Order]?
        var _error: Error?
        
        // When
        do {
            result = try await sut.execute()
        } catch {
            _error = error
        }
        
        // Then
        XCTAssertNotNil(result, "GetOrdersUseCase should return a valid order when it succeeds")
        XCTAssertNil(_error, "GetOrdersUseCase should not return an error when it succeeds")
    }
    
    func testGetOrdersUseCase_WhenRepositoryReturnsFailure_ReturnsError() async {
        // Given
        sut = GetOrdersUseCase(
            repository: FakeOrderModuleRepository(
                result: .getOrdersFailure(NetworkError.cancelled)
            )
        )
        
        var result: [Order]?
        var _error: Error?
        
        // When
        do {
            result = try await sut.execute()
        } catch {
            _error = error
        }
        
        // Then
        XCTAssertNil(result, "GetOrdersUseCase should not return a valid order when it fails")
        XCTAssertNotNil(_error, "GetOrdersUseCase should return an error when it fails")
    }
}
