//
//  MenuListViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 24/10/25.
//

import Foundation
import AppEndpoints
import Networking

public final class MenuListViewModel: ObservableObject {
    public let repository: CoffeeModuleRepository
    @Published var state: ScreenViewState = .preparing
    
    public init(repository: CoffeeModuleRepository) {
        self.repository = repository
    }
}

extension MenuListViewModel {
    @MainActor
    func makeInitialAPICalls() async {
        let _repository = self.repository
        let getMenuAPIConfig = MenuEndpoint.getMenuItems
        
        Task {
            do {
                let menu = try await _repository.getMenu(config: getMenuAPIConfig)
                print(menu)
            } catch let error as NetworkError {
                if case .decodingError(let description) = error {
                    print(description)
                }
            }
        }
    }
}
