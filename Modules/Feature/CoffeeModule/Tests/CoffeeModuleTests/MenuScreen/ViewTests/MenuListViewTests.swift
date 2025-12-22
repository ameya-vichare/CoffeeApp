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
    
    // MARK: - Mock ViewModel
    final class MockMenuListViewModel: ObservableObject, MenuListViewModel {
        @Published var state: ScreenViewState = .preparing
        @Published var datasource: [MenuListCellType] = []
        
        var alertSubject = PassthroughSubject<AlertData?, Never>()
        var alertPublisher: AnyPublisher<AlertData?, Never> {
            alertSubject.eraseToAnyPublisher()
        }
        
        var viewDidLoadCalled = false
        
        func viewDidLoad() async {
            viewDidLoadCalled = true
        }
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
