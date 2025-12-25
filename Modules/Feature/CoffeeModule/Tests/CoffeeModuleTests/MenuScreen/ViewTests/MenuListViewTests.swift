//
//  MenuListViewTests.swift
//  CoffeeModule
//
//  Created by Ameya on 22/12/25.
//

import XCTest
import Combine
import AppCore
import ViewInspector
@testable import CoffeeModule

@MainActor
final class MenuListViewTests: XCTestCase {
    var sut: MenuListView<MockMenuListViewModel>!
    var menuListViewModel: MockMenuListViewModel!
    
    final class MockMenuListViewModel: MenuListViewModel {
        var viewDidLoadCount = 0
        
        func viewDidLoad() async {
            viewDidLoadCount += 1
        }

        var state: ScreenViewState = .preparing

        var datasource: [MenuListCellType] = []

        var alertPublisher: AnyPublisher<AlertData?, Never> = PassthroughSubject<AlertData?, Never>().eraseToAnyPublisher()
    }
    
    final class MockMenuListCellViewModel: MenuListCellViewModel {
        func showMenuModifierBottomsheet() {
            
        }

        var id: Int = 0
        var name: String = "Test"
        var currency: String = "USD"
        var displayPrice: String = "10.00"
        var description: String = "Description"
        var imageURL: URL? = URL(string: "https://example.com/image.png")
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
        menuListViewModel = MockMenuListViewModel()
        sut = MenuListView(viewModel: menuListViewModel)
    }

    override func tearDownWithError() throws {
        sut = nil
        menuListViewModel = nil
        try super.tearDownWithError()
    }
    
    func testMenuListView_WhenDataSourceIsAvailable_ListOfCellsIsDisplayed() throws {
        menuListViewModel.datasource = [.mainMenu(vm: MockMenuListCellViewModel()), .mainMenu(vm: MockMenuListCellViewModel())]
        
        let cells = try sut.inspect().findAll(MenuCellView.self)
        XCTAssertEqual(cells.count, 2, "MenuListView should display one cell for each item in the data source")
    }
    
    func testMenuListView_WhenDataSourceIsNotAvailable_ListOfCellsIsNotDisplayed() throws {
        menuListViewModel.datasource = []
        
        let cells = try sut.inspect().findAll(MenuCellView.self)
        XCTAssertEqual(cells.count, 0, "MenuListView should not display any cells when data source is empty")
    }
    
    func testMenuListView_WhenStateIsFetchingData_ProgressLoaderIsShown() throws {
        menuListViewModel.state = .fetchingData
        
        let progressView = try sut.inspect().find(ViewType.ProgressView.self)
        XCTAssertNotNil(progressView, "MenuListView should show a ProgressView when state is .fetchingData")
    }
    
    func testMenuListView_WhenStateIsPreparing_ProgressLoaderIsNotShown() throws {
        menuListViewModel.state = .preparing
        
        let progressView = try? sut.inspect().find(ViewType.ProgressView.self)
        XCTAssertNil(progressView, "MenuListView should not show a ProgressView when state is .preparing")
    }
    
    func testMenuListView_WhenStateIsError_ProgressLoaderIsNotShown() throws {
        menuListViewModel.state = .error
        sut = MenuListView(viewModel: menuListViewModel)
        
        let progressView = try? sut.inspect().find(ViewType.ProgressView.self)
        XCTAssertNil(progressView,
                    "MenuListView should not show a ProgressView when state is .error")
    }
    
    func testMenuListView_WhenStateIsDataFetched_ProgressLoaderIsNotShown() throws {
        menuListViewModel.state = .dataFetched
        sut = MenuListView(viewModel: menuListViewModel)
        
        let progressView = try? sut.inspect().find(ViewType.ProgressView.self)
        XCTAssertNil(progressView,
                    "MenuListView should not show a ProgressView when state is .dataFetched")
    }
    
    func testMenuListView_WhenInitialised_ContainsList() throws {
        let list = try sut.inspect().find(ViewType.List.self)
        XCTAssertNotNil(list, "MenuListView should contain a List")
    }
}
