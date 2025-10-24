//
//  MenuListViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 24/10/25.
//

import Foundation
import AppEndpoints
import Networking
import AppModels

public final class MenuListViewModel: ObservableObject {
    public let repository: CoffeeModuleRepository
    @Published var state: ScreenViewState = .preparing
    @Published var datasource: [MenuListCellItem] = []
    
    public init(repository: CoffeeModuleRepository) {
        self.repository = repository
    }
}

extension MenuListViewModel {
    @MainActor
    func makeInitialAPICalls() async {
        let _repository = self.repository
        let getMenuAPIConfig = MenuEndpoint.getMenuItems
        self.state = .fetchingData
        
        Task {
            do {
                let response = try await _repository.getMenu(config: getMenuAPIConfig)
                if let menuList = response.menu {
                    self.prepareDatasource(menuList: menuList)
                    self.state = .dataFetched
                } else {
                    self.state = .error
                }
            } catch {
                self.state = .error
            }
        }
    }
    
    private func prepareDatasource(menuList: [MenuItem]) {
        self.datasource = menuList.compactMap { menuItem in
//            guard let menuID = menuItem.id else { return nil }
            
            return MenuListCellItem(
                id: String(menuItem.id ?? 1),
                type: .mainMenu(
                    vm: MenuCellViewModel(
                        name: menuItem.name ?? "",
                        currency: menuItem.basePriceCurrency ?? "",
                        price: menuItem.basePrice ?? 0.0,
                        description: menuItem.description ?? "",
                        imageURL: menuItem.imageURL ?? ""
                    )
                )
            )
        }
    }
}
