//
//  DefaultMenuListViewModelTests.swift
//  CoffeeModule
//
//  Created by Ameya on 14/11/25.
//

import XCTest
import Combine
import AppModels
import Networking
import NetworkMonitoring
import DesignSystem
@testable import CoffeeModule

@MainActor
final class DefaultMenuListViewModelTests: XCTestCase {
    var sut: DefaultMenuListViewModel!
    var cancellables: Set<AnyCancellable> = []
    
    final class NetworkMonitoringMock: NetworkMonitoring {
        let status: NetworkStatus
        let monitoringSubject: PassthroughSubject<NetworkStatus, Never>

        var monitoringPublisher: AnyPublisher<NetworkStatus, Never> {
            monitoringSubject.eraseToAnyPublisher()
        }

        func start() {
        }

        func stop() {
        }
        
        init(status: NetworkStatus, monitoringSubject: PassthroughSubject<NetworkStatus, Never> = PassthroughSubject<NetworkStatus, Never>()) {
            self.status = status
            self.monitoringSubject = monitoringSubject
        }
    }
    
    final class MockGetMenuUseCase: GetMenuUsecaseProtocol {
        enum Result {
            case success(MenuResponse)
            case failure(NetworkError)
            case genericError(Error)
        }
        
        let result: Result
        
        init(result: Result) {
            self.result = result
        }
        
        func execute() async throws -> MenuResponse {
            switch result {
            case .success(let menuResponse):
                return menuResponse
            case .failure(let networkError):
                throw networkError
            case .genericError(let error):
                throw error
            }
        }
    }
    
    final class MockCreateOrderUsecase: CreateOrderUsecaseProtocol {
        enum Result {
            case success(CreateOrderResponse)
            case failure(OrderModuleUsecaseError)
            case genericError(Error)
        }
        
        let result: Result
        
        init(result: Result) {
            self.result = result
        }
        
        func execute(using orderItem: CreateOrderItem) async throws -> CreateOrderResponse {
            switch result {
            case .success(let createOrderResponse):
                return createOrderResponse
            case .failure(let networkError):
                throw networkError
            case .genericError(let error):
                throw error
            }
        }
    }
    
    final class MockRetryPendingOrdersUsecase: RetryPendingOrdersUsecaseProtocol {
        enum Result {
            case success
            case failure(NetworkError)
            case genericError(OrderRepositoryError)
        }
        
        let result: Result
        
        init(result: Result) {
            self.result = result
        }
        
        func execute() async throws {
            switch result {
            case .success:
                break
            case .failure(let networkError):
                throw networkError
            case .genericError(let error):
                throw error
            }
        }
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
    }

    override func tearDownWithError() throws {
        cancellables.removeAll()
        try super.tearDownWithError()
    }
    
    func testDefaultMenuListViewModel_WhenInitiated_DataSourceIsEmptyAndStateIsPreparing() {
        // Given
        sut = DefaultMenuListViewModel(
            networkMonitor: NetworkMonitoringMock(status: .available),
            getMenuUseCase: MockGetMenuUseCase(
                result: .success(MenuResponse.createFake())
            ),
            createOrderUseCase: MockCreateOrderUsecase(
                result: .success(CreateOrderResponse.createFake())
            ),
            retryPendingOrdersUsecase: MockRetryPendingOrdersUsecase(
                result: .success
            )
        )
        // When
        
        // Then
        XCTAssertTrue(
            sut.datasource.isEmpty,
            "DefaultMenuListViewModel's datasource should be empty initially"
        )
        XCTAssertEqual(
            sut.state,
            .preparing,
            "DefaultMenuListViewModel's state should be .preparing initially"
        )
    }
    
    func testDefaultMenuListViewModel_WhenGetMenuUseCaseSucceeds_DatasourceAndStateShouldBeValid() async throws {
        // Given
        sut = DefaultMenuListViewModel(
            networkMonitor: NetworkMonitoringMock(status: .available),
            getMenuUseCase: MockGetMenuUseCase(
                result: .success(MenuResponse.createFake())
            ),
            createOrderUseCase: MockCreateOrderUsecase(
                result: .success(CreateOrderResponse.createFake())
            ),
            retryPendingOrdersUsecase: MockRetryPendingOrdersUsecase(
                result: .success
            )
        )
        
        // When
        await sut.viewDidLoad()
        
        // Then
        XCTAssertEqual(
            sut.datasource.count,
            1,
            "DefaultMenuListViewModel's datasource should have 1 item"
        )
        XCTAssertEqual(
            sut.state,
            .dataFetched,
            "DefaultMenuListViewModel's state should be .dataFetched"
        )
    }
    
    func testDefaultMenuListViewModel_WhenGetMenuUseCaseFails_DatasourceIsEmptyAndAlertIsShown() async throws {
        // Given
        sut = DefaultMenuListViewModel(
            networkMonitor: NetworkMonitoringMock(status: .available),
            getMenuUseCase: MockGetMenuUseCase(
                result: .failure(NetworkError.cancelled)
            ),
            createOrderUseCase: MockCreateOrderUsecase(
                result: .success(CreateOrderResponse.createFake())
            ),
            retryPendingOrdersUsecase: MockRetryPendingOrdersUsecase(
                result: .success
            )
        )
        
        let expectation = XCTestExpectation(description: "An alert should be shown")
        var alertData: AlertData?
        
        // When
        sut.alertPublisher.sink { _alertData in
            alertData = _alertData
            expectation.fulfill()
        }
        .store(in: &cancellables)
        
        await sut.viewDidLoad()
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertEqual(
            sut.datasource.count,
            0,
            "DefaultMenuListViewModel's datasource should have 0 item when the network request fails"
        )
        XCTAssertEqual(
            sut.state,
            .error,
            "DefaultMenuListViewModel's state should be .error"
        )
        XCTAssertNotNil(
            alertData,
            "DefaultMenuListViewModel's alertData should not be nil"
        )
        XCTAssertEqual(
            alertData?.message,
            NetworkError.cancelled.message,
            "DefaultMenuListViewModel's alertData message should match the error message"
        )
        XCTAssertEqual(
            alertData?.title,
            NetworkError.cancelled.title,
            "DefaultMenuListViewModel's alertData title should match the error title"
        )
    }
    
    func testDefaultMenuListViewModel_WhenGetMenuUseCaseFailsWithGenericError_DatasourceIsEmptyAndAlertIsNotShown() async throws {
        struct DummyError: Error {}
        // Given
        sut = DefaultMenuListViewModel(
            networkMonitor: NetworkMonitoringMock(status: .available),
            getMenuUseCase: MockGetMenuUseCase(
                result: .genericError(DummyError())
            ),
            createOrderUseCase: MockCreateOrderUsecase(
                result: .success(CreateOrderResponse.createFake())
            ),
            retryPendingOrdersUsecase: MockRetryPendingOrdersUsecase(
                result: .success
            )
        )
        
        var alertData: AlertData?
        
        // When
        sut.alertPublisher.sink { _alertData in
            alertData = _alertData
        }
        .store(in: &cancellables)
        
        await sut.viewDidLoad()
        
        // Then
        XCTAssertEqual(
            sut.datasource.count,
            0,
            "DefaultMenuListViewModel's datasource should have 0 item when the network request fails"
        )
        XCTAssertEqual(
            sut.state,
            .error,
            "DefaultMenuListViewModel's state should be .error"
        )
        XCTAssertNil(
            alertData,
            "DefaultMenuListViewModel's alertData should be nil"
        )
    }
    
    func testDefaultMenuListViewModel_WhenCreateOrderUseCaseSucceeds_SuccessAlertIsShown() async throws {
        // Given
        sut = DefaultMenuListViewModel(
            networkMonitor: NetworkMonitoringMock(status: .available),
            getMenuUseCase: MockGetMenuUseCase(
                result: .success(MenuResponse.createFake())
            ),
            createOrderUseCase: MockCreateOrderUsecase(
                result: .success(CreateOrderResponse.createFake())
            ),
            retryPendingOrdersUsecase: MockRetryPendingOrdersUsecase(
                result: .success
            )
        )
        let expectation = XCTestExpectation(description: "A success alert should be shown")
        var alertData: AlertData?
        
        // When
        sut.alertPublisher.sink { _alertData in
            alertData = _alertData
            expectation.fulfill()
        }.store(in: &cancellables)
        
        sut.orderItemUpdatesSubject
            .send(
                CreateOrderItem(itemID: 0, quantity: 1, optionIDs: [1,2])
            )
        
        await fulfillment(of: [expectation], timeout: 1)
        
        // Then
        XCTAssertNotNil(
            alertData,
            "DefaultMenuListViewModel's alertData should not be nil"
        )
        XCTAssertEqual(
            alertData?.title,
            "Order Success",
            "DefaultMenuListViewModel's alertData title should match the success title"
        )
        XCTAssertEqual(
            alertData?.message,
            "Your order has been placed!",
            "DefaultMenuListViewModel's alertData message should match the success message"
        )
    }
    
    func testDefaultMenuListViewModel_WhenCreateOrderUseCaseFails_ErrorAlertIsShown() async throws {
        // Given
        sut = DefaultMenuListViewModel(
            networkMonitor: NetworkMonitoringMock(status: .available),
            getMenuUseCase: MockGetMenuUseCase(
                result: .success(MenuResponse.createFake())
            ),
            createOrderUseCase: MockCreateOrderUsecase(
                result: .failure(OrderModuleUsecaseError.creatingOrderFailed)
            ),
            retryPendingOrdersUsecase: MockRetryPendingOrdersUsecase(
                result: .success
            )
        )
        let expectation = XCTestExpectation(description: "An error alert should be shown")
        var alertData: AlertData?
        
        // When
        sut.alertPublisher.sink { _alertData in
            alertData = _alertData
            expectation.fulfill()
        }.store(in: &cancellables)
        
        sut.orderItemUpdatesSubject
            .send(
                CreateOrderItem(itemID: 0, quantity: 1, optionIDs: [1,2])
            )
        
        await fulfillment(of: [expectation], timeout: 1)
        
        // Then
        XCTAssertNotNil(
            alertData,
            "DefaultMenuListViewModel's alertData should not be nil"
        )
        XCTAssertEqual(
            alertData?.title,
            OrderModuleUsecaseError.creatingOrderFailed.title,
            "DefaultMenuListViewModel's alertData title should match the error title"
        )
        XCTAssertEqual(
            alertData?.message,
            OrderModuleUsecaseError.creatingOrderFailed.message,
            "DefaultMenuListViewModel's alertData message should match the error message"
        )
    }
    
    func testDefaultMenuListViewModel_WhenResponseMenuIsNil_DataSourceIsEmpty() async throws {
        // Given
        sut = DefaultMenuListViewModel(
            networkMonitor: NetworkMonitoringMock(status: .available),
            getMenuUseCase: MockGetMenuUseCase(
                result: .success(MenuResponse.createFake(menu: nil))
            ),
            createOrderUseCase: MockCreateOrderUsecase(
                result: .failure(OrderModuleUsecaseError.creatingOrderFailed)
            ),
            retryPendingOrdersUsecase: MockRetryPendingOrdersUsecase(
                result: .success
            )
        )
        
        // When
        await sut.viewDidLoad()
        
        // Then
        XCTAssertTrue(sut.datasource.isEmpty, "DefaultMenuListViewModel's datasource should be empty when response menu is nil")
    }
    
    func testDefaultMenuListViewModel_WhenNetworkConnectionIsAvailable_PendingOrdersAreRetried() async throws {
        // Given
        let monitoringSubject = PassthroughSubject<NetworkStatus, Never>()
        let networkMonitor = NetworkMonitoringMock(
            status: .available,
            monitoringSubject: monitoringSubject
        )
        sut = DefaultMenuListViewModel(
            networkMonitor: networkMonitor,
            getMenuUseCase: MockGetMenuUseCase(
                result: .success(MenuResponse.createFake(menu: nil))
            ),
            createOrderUseCase: MockCreateOrderUsecase(
                result: .failure(OrderModuleUsecaseError.creatingOrderFailed)
            ),
            retryPendingOrdersUsecase: MockRetryPendingOrdersUsecase(
                result: .success
            )
        )
        let expectation = XCTestExpectation(description: "Order retry success alert is displayed.")
        var alertData: AlertData?
        
        // When
        sut.alertPublisher.sink { _alertData in
            alertData = _alertData
            expectation.fulfill()
        }
        .store(in: &cancellables)
        
        monitoringSubject.send(.available)
        
        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
        
        XCTAssertNotNil(
            alertData,
            "Alert data should not be nil"
        )
        XCTAssertEqual(
            alertData?.title,
            "Order Retry Success",
            "Alert title should be proper"
        )
        XCTAssertEqual(
            alertData?.message,
            "We have sent your previously failed order!",
            "Alert message should be proper"
        )
    }
    
    func testDefaultMenuListViewModel_WhenNetworkConnectionIsUnavailable_PendingOrdersAreNotRetried() async throws {
        // Given
        let monitoringSubject = PassthroughSubject<NetworkStatus, Never>()
        let networkMonitor = NetworkMonitoringMock(
            status: .available,
            monitoringSubject: monitoringSubject
        )
        sut = DefaultMenuListViewModel(
            networkMonitor: networkMonitor,
            getMenuUseCase: MockGetMenuUseCase(
                result: .success(MenuResponse.createFake(menu: nil))
            ),
            createOrderUseCase: MockCreateOrderUsecase(
                result: .failure(OrderModuleUsecaseError.creatingOrderFailed)
            ),
            retryPendingOrdersUsecase: MockRetryPendingOrdersUsecase(
                result: .success
            )
        )
        let expectation = XCTestExpectation(description: "Order retry success alert is not displayed.")
        var alertData: AlertData?
        
        // When
        sut.alertPublisher.sink { _alertData in
            alertData = _alertData
            expectation.fulfill()
        }
        .store(in: &cancellables)
        
        monitoringSubject.send(.unavailable)
        
        // Then
        let expectationResult = await XCTWaiter.fulfillment(of: [expectation], timeout: 2.0)
        
        switch expectationResult {
        case .timedOut:
            XCTAssertNil(
                alertData,
                "Alert data should be nil"
            )
        case .completed:
            XCTFail("The expectation should not have fullfilled")
        default:
            XCTFail("The expectation should not have fullfilled")
        }
    }
    
    func testDefaultMenuListViewModel_WhenRetryPendingOrderFails_AnErrorAlertIsShown() async throws {
        // Given
        let monitoringSubject = PassthroughSubject<NetworkStatus, Never>()
        let networkMonitor = NetworkMonitoringMock(
            status: .available,
            monitoringSubject: monitoringSubject
        )
        sut = DefaultMenuListViewModel(
            networkMonitor: networkMonitor,
            getMenuUseCase: MockGetMenuUseCase(
                result: .success(MenuResponse.createFake(menu: nil))
            ),
            createOrderUseCase: MockCreateOrderUsecase(
                result: .failure(OrderModuleUsecaseError.creatingOrderFailed)
            ),
            retryPendingOrdersUsecase: MockRetryPendingOrdersUsecase(
                result: .failure(NetworkError.cancelled)
            )
        )
        let expectation = XCTestExpectation(description: "An error alert should be shown")
        var alertData: AlertData?
        
        // When
        sut.alertPublisher.sink { _alertData in
            alertData = _alertData
            expectation.fulfill()
        }
        .store(in: &cancellables)
        
        monitoringSubject.send(.available)
        
        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertNotNil(
            alertData,
            "DefaultMenuListViewModel's alertData should not be nil"
        )
        XCTAssertEqual(
            alertData?.title,
            NetworkError.cancelled.title,
            "DefaultMenuListViewModel's alertData title should match the error title"
        )
        XCTAssertEqual(
            alertData?.message,
            NetworkError.cancelled.message,
            "DefaultMenuListViewModel's alertData message should match the error message"
        )
    }
}
