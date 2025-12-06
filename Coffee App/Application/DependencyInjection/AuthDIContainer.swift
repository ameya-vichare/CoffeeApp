//
//  AuthDIContainer.swift
//  Coffee App
//
//  Created by Ameya on 01/12/25.
//

import SwiftUI
import AuthModule

final class AuthDIContainer {
    struct Dependencies {
        let authRepository: AuthRepositoryProtocol
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
    func makeLoginView() -> AnyView {
        func makeLoginViewModel() -> DefaultLoginViewModel {
            DefaultLoginViewModel(
                userLoginUseCase: UserLoginUseCase(
                    repository: dependencies.authRepository
                )
            )
        }
        
        let loginView = LoginView(viewModel: makeLoginViewModel())
        
        return AnyView(loginView)
    }
}
