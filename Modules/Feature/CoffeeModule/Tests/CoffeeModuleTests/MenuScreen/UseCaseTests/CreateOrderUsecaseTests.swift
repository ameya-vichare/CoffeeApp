//
//  CreateOrderUsecaseTests.swift
//  CoffeeModule
//
//  Created by Ameya on 16/11/25.
//

import XCTest
import AppCore
import NetworkMonitoring
import Networking
@testable import CoffeeModule

final class CreateOrderUsecaseTests: XCTestCase {
    var sut: CreateOrderUsecase!

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testCreateOrderUsecase_WhenNetworkIsUnavailable_ShouldStoreOrderAndReturnError() async {
        // Given
        let repository = FakeOrderModuleRepository()
        sut = CreateOrderUsecase(
            repository: repository,
            networkMonitor: FakeNetworkMonitor(status: .unavailable)
        )
        
        var response: CreateOrderResponse?
        var _error: OrderModuleUsecaseError?
        
        // When
        do {
            response = try await sut.execute(
                using: CreateOrderItem(
                    itemID: 1,
                    quantity: 1,
                    optionIDs: [1,2]
                )
            )
        } catch let error as OrderModuleUsecaseError {
            _error = error
        } catch {}
        
        // Then
        XCTAssertNil(response, "CreateOrderUsecase's response should be nil when network is unavailable")
        XCTAssertEqual(_error, OrderModuleUsecaseError.creatingOrderFailed, "CreateOrderUsecase should throw appropriate error when network is unavailable")
        XCTAssertEqual(repository.storeOrderCount, 1, "CreateOrderUsecase should store order when network is unavailable")
    }
    
    func testCreateOrderUsecase_WhenNetworkIsAvailable_ShouldReturnValidResponse() async {
        // Given
        let repository = FakeOrderModuleRepository(
            result: .createOrderSuccess(CreateOrderResponse.createFake())
        )
        sut = CreateOrderUsecase(
            repository: repository,
            networkMonitor: FakeNetworkMonitor(status: .available)
        )
        
        var response: CreateOrderResponse?
        var _error: OrderModuleUsecaseError?
        
        // When
        do {
            response = try await sut.execute(
                using: CreateOrderItem(
                    itemID: 1,
                    quantity: 1,
                    optionIDs: [1,2]
                )
            )
        } catch let error as OrderModuleUsecaseError {
            _error = error
        } catch {}
        
        // Then
        XCTAssertNotNil(response, "CreateOrderUsecase's response should be valid when network is available")
        XCTAssertNil(_error, "CreateOrderUsecase should not throw an error when network is available")
        XCTAssertEqual(repository.storeOrderCount, 0, "CreateOrderUsecase should not store an order when network is available")
    }
    
    func testCreateOrderUsecase_WhenRepositoryReturnsError_ShouldThrowUsecaseError() async {
        // Given
        let repository = FakeOrderModuleRepository(
            result: .createOrderFailure(NetworkError.cancelled)
        )
        sut = CreateOrderUsecase(
            repository: repository,
            networkMonitor: FakeNetworkMonitor(status: .available)
        )
        
        var response: CreateOrderResponse?
        var _error: OrderModuleUsecaseError?
        
        // When
        do {
            response = try await sut.execute(
                using: CreateOrderItem(
                    itemID: 1,
                    quantity: 1,
                    optionIDs: [1,2]
                )
            )
        } catch let error as OrderModuleUsecaseError {
            _error = error
        } catch {}
        
        // Then
        XCTAssertNil(response, "CreateOrderUsecase's response should be nil when repository returns an error")
        XCTAssertEqual(
            _error,
            OrderModuleUsecaseError.creatingOrderFailed,
            "CreateOrderUsecase should throw appropriate error when repository returns an error"
        )
    }
}
