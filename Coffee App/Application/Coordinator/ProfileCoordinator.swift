//
//  ProfileCoordinator.swift
//  Coffee App
//
//  Created by Ameya on 29/12/25.
//

import SwiftUI
import AppCore
import ProfileModule

protocol ProfileCoordinatorDependencyDelegate: AnyObject {
    func makeProfileView(navigationDelegate: ProfileViewNavigationDelegate) -> AnyView
    func onUserLogoutSuccess()
}

final class ProfileCoordinator: Coordinator {
    var navigationController: UINavigationController
    let dependencyDelegate: ProfileCoordinatorDependencyDelegate
    
    init(
        navigationController: UINavigationController,
        dependencyDelegate: ProfileCoordinatorDependencyDelegate
    ) {
        self.navigationController = navigationController
        self.dependencyDelegate = dependencyDelegate
    }

    func start() {
        let profileView = UIHostingController(
            rootView: self.dependencyDelegate.makeProfileView(navigationDelegate: self)
        )
        self.navigationController.pushViewController(profileView, animated: true)
    }
}

// MARK: - Navigation handling
extension ProfileCoordinator: ProfileViewNavigationDelegate {
    @MainActor
    func onUserLogoutSuccess() {
        self.dependencyDelegate.onUserLogoutSuccess()
    }
}
