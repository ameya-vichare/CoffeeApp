//
//  ProfileDIContainer.swift
//  Coffee App
//
//  Created by Ameya on 29/12/25.
//

import SwiftUI
import ProfileModule

final class ProfileDIContainer {
    
    init() {}
    
    func makeProfileCoordinator(navigationController: UINavigationController) -> ProfileCoordinator {
        ProfileCoordinator(
            navigationController: navigationController,
            dependencyDelegate: self
        )
    }
}

extension ProfileDIContainer: ProfileCoordinatorDependencyDelegate {
    @MainActor
    func makeProfileView() -> AnyView {
        let profileViewModel = DefaultProfileViewModel()
        let profileView = ProfileView(viewModel: profileViewModel)
        return AnyView(profileView)
    }
}
