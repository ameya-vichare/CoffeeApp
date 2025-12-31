//
//  ProfileDIContainer.swift
//  Coffee App
//
//  Created by Ameya on 29/12/25.
//

import SwiftUI
import ProfileModule
import AuthModule
import Resolver
import AppCore

final class ProfileDIContainer {
    struct Dependencies {
        let onUserLogoutSuccess: () -> Void
    }
    
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeProfileCoordinator(navigationController: UINavigationController) -> ProfileCoordinator {
        ProfileCoordinator(
            navigationController: navigationController,
            dependencyDelegate: self
        )
    }
}

extension ProfileDIContainer: ProfileCoordinatorDependencyDelegate {
    @MainActor
    func makeProfileView(navigationDelegate: ProfileViewNavigationDelegate) -> AnyView {
        func makeProfileViewModel() -> DefaultProfileViewModel {
            DefaultProfileViewModel(
                logoutUseCase: UserLogoutUseCase(
                    repository: Resolver.resolve(AuthRepositoryProtocol.self)
                ),
                navigationDelegate: navigationDelegate
            )
        }
        
        let profileView = ProfileView(viewModel: makeProfileViewModel())
        return AnyView(profileView)
    }
    
    func onUserLogoutSuccess() {
        self.dependencies.onUserLogoutSuccess()
    }
}
