//
//  DefaultOrderListViewModelTests.swift
//  CoffeeModule
//
//  Created by Ameya on 13/11/25.
//

import XCTest
import AppCore
import Networking
import Combine
@testable import CoffeeModule

@MainActor
final class DefaultOrderListViewModelTests: XCTestCase {
    
    var sut: DefaultOrderListViewModel!
    var cancelleables: Set<AnyCancellable> = []
    
    final class MockGetOrdersUseCase: GetOrdersUseCaseProtocol {
        enum Result {
            case success([Order])
            case failure(NetworkError)
            case genericError(Error)
        }
        
        let result: Result
        
        init(result: Result) {
            self.result = result
        }
        
        func execute() async throws -> [Order] {
            switch result {
            case .success(let orders):
                return orders
            case .failure(let error):
                throw error
            case .genericError(let error):
                throw error
            }
        }
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        cancelleables.removeAll()
        try super.tearDownWithError()
    }
    
    func testDefaultOrderListViewModel_WhenInitialState_DatasourceIsEmptyAndStateIsPreparing() {
        // Given
        sut = DefaultOrderListViewModel(
            getOrdersUseCase: MockGetOrdersUseCase(result: .success([])),
            navigationDelegate: nil
        )
        
        // When
        
        // Then
        XCTAssertTrue(sut.datasource.isEmpty, "DefaultOrderListViewModel's datasource should have been empty initially.")
        XCTAssertEqual(sut.state, .preparing, "DefaultOrderListViewModel's state should be .preparing initially.")
    }
    
    func testDefaultOrderListViewModel_WhenGetOrdersSucceeds_DatasourceCountIsCorrectAndStateIsDataFetched() async {
        // Given
        sut = DefaultOrderListViewModel(
            getOrdersUseCase: MockGetOrdersUseCase(
                result: .success([Order.createFake(), Order.createFake()])
            ),
            navigationDelegate: nil
        )
        
        // When
        await sut.viewDidLoad()
        
        // Then
        XCTAssertEqual(sut.datasource.count, 2, "DefaultOrderListViewModel's datasource count should be 2 after getting orders succeeds.")
        XCTAssertEqual(sut.state, .dataFetched, "DefaultOrderListViewModel's state should be .dataFetched when getting orders succeeds.")
    }
    
    func testDefaultOrderListViewModel_WhenGetOrdersFails_DatasourceIsEmptyAndAlertIsReceived() async {
        // Given
        sut = DefaultOrderListViewModel(
            getOrdersUseCase: MockGetOrdersUseCase(
                result: .failure(NetworkError.noInternet)
            ),
            navigationDelegate: nil
        )
        let expectation = XCTestExpectation(description: "An alert should be received.")
        var alertData: AlertData?
        
        sut.alertPublisher.sink { _alertData in
            alertData = _alertData
            expectation.fulfill()
        }
        .store(in: &cancelleables)
        
        // When
        await sut.viewDidLoad()
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertTrue(sut.datasource.isEmpty, "DefaultOrderListViewModel's datasource count should be empty if get orders fails.")
        XCTAssertNotNil(alertData, "DefaultOrderListViewModel should receive an alert when get orders fails with NetworkError.")
        XCTAssertEqual(alertData?.message, NetworkError.noInternet.message, "DefaultOrderListViewModel should receive an alert with the correct message when get orders fails with NetworkError.")
        XCTAssertEqual(alertData?.title, NetworkError.noInternet.title, "DefaultOrderListViewModel should receive an alert with the correct title when get orders fails with NetworkError.")
    }
    
    func testDefaultOrderListViewModel_WhenGetOrdersFailsWithGenericError_DatasourceIsEmptyAndAlertIsNotReceived() async {
        struct DummyError: Error {}
        // Given
        sut = DefaultOrderListViewModel(
            getOrdersUseCase: MockGetOrdersUseCase(
                result: .genericError(DummyError())
            ),
            navigationDelegate: nil
        )
        var alertData: AlertData?
        
        sut.alertPublisher.sink { _alertData in
            alertData = _alertData
        }
        .store(in: &cancelleables)
        
        // When
        await sut.viewDidLoad()
        
        // Then
        XCTAssertTrue(sut.datasource.isEmpty, "DefaultOrderListViewModel's datasource count should be empty if get orders fails with generic error.")
        XCTAssertNil(alertData, "DefaultOrderListViewModel should not receive an alert when get orders fails with generic error.")
    }
    
    func testDefaultOrderListViewModel_WhenUserRefreshesScreen_DatasourceCountIsCorrectAndStateIsDataFetched() async {
        // Given
        sut = DefaultOrderListViewModel(
            getOrdersUseCase: MockGetOrdersUseCase(
                result: .success([Order.createFake(), Order.createFake()])
            ),
            navigationDelegate: nil
        )
        
        // When
        await sut.didRefresh()
        
        // Then
        XCTAssertEqual(sut.datasource.count, 2, "DefaultOrderListViewModel's datasource count should be 2 after getting orders succeeds.")
        XCTAssertEqual(sut.state, .dataFetched, "DefaultOrderListViewModel's state should be .dataFetched when getting orders succeeds.")
    }
    
    func testDefaultOrderListViewModel_WhenOrderWithEmptyIDIsReceived_ItGetsFilteredOut() async {
        // Given
        sut = DefaultOrderListViewModel(
            getOrdersUseCase: MockGetOrdersUseCase(
                result: .success(
                    [Order.createFake(), Order.createFake(orderId: "")]
                )
            ),
            navigationDelegate: nil
        )
        
        // When
        await sut.viewDidLoad()
        
        // Then
        XCTAssertEqual(sut.datasource.count, 1, "DefaultOrderListViewModel's datasource count should be 1 after filtering out the order with empty ID.")
    }
}
