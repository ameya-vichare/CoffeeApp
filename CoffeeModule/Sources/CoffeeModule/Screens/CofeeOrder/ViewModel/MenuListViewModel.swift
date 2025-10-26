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
        self.datasource = menuList.compactMap { (menuItem) -> MenuListCellItem? in
            // Require modifiers to build bottom sheet; skip items without them
            guard let modifiers = menuItem.modifiers else { return nil }

            // Build modifier view models explicitly typing the element type
            let menuModifierViewModels: [MenuModifierViewModel] = modifiers.compactMap { (menuModifier) -> MenuModifierViewModel? in
                guard let options = menuModifier.options else { return nil }

                // Build option cell view models with explicit element type
                let menuModifierCellViewModels: [MenuModifierCellViewModel] = options.map { option in
                    MenuModifierCellViewModel(
                        id: option.id ?? 0,
                        name: option.name ?? "",
                        price: option.price ?? 0.0,
                        currency: option.currency ?? "",
                        isDefault: option.isDefault ?? false
                    )
                }

                return MenuModifierViewModel(
                    id: menuModifier.id ?? 0,
                    name: menuModifier.name ?? "",
                    minSelection: menuModifier.minSelect ?? 0,
                    maxSelection: menuModifier.maxSelect ?? 0,
                    options: menuModifierCellViewModels
                )
            }

            return MenuListCellItem(
                id: String(menuItem.id ?? 1),
                type: .mainMenu(
                    vm: MenuCellViewModel(
                        name: menuItem.name ?? "",
                        currency: menuItem.currency ?? "",
                        price: menuItem.basePrice ?? 0.0,
                        description: menuItem.description ?? "",
                        imageURL: menuItem.imageURL ?? "",
                        bottomSheetModel: MenuModifierBottomSheetViewModel(
                            modifierViewModels: menuModifierViewModels
                        )
                    )
                )
            )
        }
    }
}
