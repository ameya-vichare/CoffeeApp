//
//  GetMenuUsecaseTests.swift
//  CoffeeModule
//
//  Created by Ameya on 18/11/25.
//

import XCTest
import AppCore
import Networking
@testable import CoffeeModule

final class GetMenuUsecaseTests: XCTestCase {
    
    var sut: GetMenuUsecase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testGetMenuUseCase_WhenRepositoryReturnsSuccess_ShouldReturnMenu() async {
        // Given
        sut = GetMenuUsecase(
            repository: FakeOrderModuleRepository(
                result: .getMenuSuccess(MenuResponse.createFake())
            )
        )
        var response: MenuResponse?
        var _error: Error?
        
        
        // When
        do {
            response = try await sut.execute()
        } catch {
            _error = error
        }
        
        // Then
        XCTAssertNil(_error, "GetMenuUseCase should not throw an error when repostory returns success")
        XCTAssertNotNil(response, "GetMenuUseCase should return a menu when repostory returns success")
    }
    
    func testGetMenuUseCase_WhenRepositoryReturnsFailure_ShouldReturnError() async {
        // Given
        sut = GetMenuUsecase(
            repository: FakeOrderModuleRepository(
                result: .createOrderFailure(NetworkError.cancelled)
            )
        )
        var response: MenuResponse?
        var _error: NetworkError?
        
        
        // When
        do {
            response = try await sut.execute()
        } catch let error as NetworkError {
            _error = error
        } catch {}
        
        // Then
        XCTAssertEqual(_error, NetworkError.cancelled, "GetMenuUseCase should throw an appropriate error when repostory returns failure")
        XCTAssertNil(response, "GetMenuUseCase should not return a response when repostory returns failure")
    }
}
