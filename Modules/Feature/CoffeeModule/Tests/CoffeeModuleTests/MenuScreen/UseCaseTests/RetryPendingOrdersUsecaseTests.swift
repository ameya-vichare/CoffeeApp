//
//  RetryPendingOrdersUsecaseTests.swift
//  CoffeeModule
//
//  Created by Ameya on 18/11/25.
//

import XCTest
import Networking
@testable import CoffeeModule

final class RetryPendingOrdersUsecaseTests: XCTestCase {
    
    var sut: RetryPendingOrdersUsecase!

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testRetryPendingOrdersUsecase_WhenRepositoryReturnsSuccess_ShouldNotThrowError() async {
        // Given
        sut = RetryPendingOrdersUsecase(
            repository: FakeOrderModuleRepository(
                result: .retryPendingOrdersSuccess
            )
        )
        var _error: Error?
        
        // When
        do {
            try await sut.execute()
        } catch {
            _error = error
        }
        
        // Then
        XCTAssertNil(_error, "RetryPendingOrdersUsecase should not throw an error when repostory returns success")
    }
    
    func testRetryPendingOrdersUsecase_WhenRepositoryReturnsFailure_ShouldThrowAnError() async {
        // Given
        sut = RetryPendingOrdersUsecase(
            repository: FakeOrderModuleRepository(
                result: .retryPendingOrdersFailure(
                    NetworkError.cancelled
                )
            )
        )
        var _error: NetworkError?
        
        // When
        do {
            try await sut.execute()
        } catch let error as NetworkError {
            _error = error
        } catch {}
        
        // Then
        XCTAssertEqual(_error, NetworkError.cancelled, "")
    }
}
