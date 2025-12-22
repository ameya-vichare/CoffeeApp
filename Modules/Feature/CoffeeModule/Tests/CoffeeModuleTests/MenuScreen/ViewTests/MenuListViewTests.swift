//
//  MenuListViewTests.swift
//  CoffeeModule
//
//  Created by Ameya on 22/12/25.
//

import XCTest
import Combine
import AppCore
@testable import CoffeeModule

@MainActor
final class MenuListViewTests: XCTestCase {
    
    class MockMenuListViewModel: MenuListViewModel {
        func viewDidLoad() async {
            
        }

        var state: CoffeeModule.ScreenViewState = .preparing

        var datasource: [CoffeeModule.MenuListCellType] = []

        var alertPublisher: AnyPublisher<AlertData?, Never> = PassthroughSubject().eraseToAnyPublisher()
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func testMenuListView_CanBeInitializedWithMock() {
        // Given
        let mockViewModel = MockMenuListViewModel()
        
        // When
        let view = MenuListView(viewModel: mockViewModel)
        
        // Then
        XCTAssertNotNil(view, "MenuListView should be initialized with mock view model")
    }
}
