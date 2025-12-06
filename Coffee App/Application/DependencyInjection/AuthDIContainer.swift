//
//  AuthDIContainer.swift
//  Coffee App
//
//  Created by Ameya on 01/12/25.
//

import SwiftUI
import AuthModule
import AppModels

final class AuthDIContainer {
    struct Dependencies {
        let authRepository: AuthRepositoryProtocol
        let makeTabBarCoordinator: (UINavigationController) -> TabBarCoordinator
        let updateUserSession: (UserSession) -> Void
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeAuthCoordinator(navigationController: UINavigationController) -> AuthCoordinator {
        AuthCoordinator(
            navigationController: navigationController,
            dependencyDelegate: self
        )
    }
}

extension AuthDIContainer: AuthCoordinatorDependencyDelegate {
    @MainActor
    func makeLoginView(navigationDelegate: LoginViewNavigationDelegate) -> AnyView {
        func makeLoginViewModel() -> DefaultLoginViewModel {
            DefaultLoginViewModel(
                userLoginUseCase: UserLoginUseCase(
                    repository: dependencies.authRepository
                ),
                navigationDelegate: navigationDelegate
            )
        }
        
        let loginView = LoginView(viewModel: makeLoginViewModel())
        
        return AnyView(loginView)
    }
    
    func makeTabBarCoordinator(navigationController: UINavigationController) -> TabBarCoordinator {
        dependencies.makeTabBarCoordinator(navigationController)
    }
    
    func updateUserSession(_ userSession: UserSession) {
        dependencies.updateUserSession(userSession)
    }
}
