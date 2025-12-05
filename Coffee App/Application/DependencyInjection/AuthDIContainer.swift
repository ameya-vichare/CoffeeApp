//
//  AuthDIContainer.swift
//  Coffee App
//
//  Created by Ameya on 01/12/25.
//

import SwiftUI
import AuthModule

final class AuthDIContainer {
    init() {
        
    }
    
    func makeAuthCoordinator(navigationController: UINavigationController) -> AuthCoordinator {
        AuthCoordinator(
            navigationController: navigationController,
            dependencyDelegate: self
        )
    }
}

extension AuthDIContainer: AuthCoordinatorDependencyDelegate {
    func makeLoginView() -> AnyView {
        func makeLoginViewModel() -> DefaultLoginViewModel {
            DefaultLoginViewModel()
        }
        
        let loginView = LoginView(viewModel: makeLoginViewModel())
        
        return AnyView(loginView)
    }
}
