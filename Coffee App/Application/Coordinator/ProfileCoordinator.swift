//
//  ProfileCoordinator.swift
//  Coffee App
//
//  Created by Ameya on 29/12/25.
//

import SwiftUI

protocol ProfileCoordinatorDependencyDelegate: AnyObject {
    func makeProfileView() -> AnyView
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
            rootView: self.dependencyDelegate.makeProfileView()
        )
        self.navigationController.pushViewController(profileView, animated: true)
    }
}
