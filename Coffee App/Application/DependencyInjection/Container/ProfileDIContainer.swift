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
    func makeProfileView() -> AnyView {
        AnyView(ProfileView())
    }
}
