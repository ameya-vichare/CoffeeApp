//
//  AuthCoordinator.swift
//  Coffee App
//
//  Created by Ameya on 01/12/25.
//

import SwiftUI
import AuthModule
import AppModels

protocol AuthCoordinatorDependencyDelegate {
    func makeLoginView(navigationDelegate: LoginViewNavigationDelegate) -> AnyView
}

final class AuthCoordinator: Coordinator {
    let navigationController: UINavigationController
    let dependencyDelegate: AuthCoordinatorDependencyDelegate
    
    init(navigationController: UINavigationController,
         dependencyDelegate: AuthCoordinatorDependencyDelegate
    ) {
        self.navigationController = navigationController
        self.dependencyDelegate = dependencyDelegate
    }

    func start() {
        let loginView = dependencyDelegate.makeLoginView(navigationDelegate: self)
        let hostController = UIHostingController(rootView: loginView)
        navigationController.pushViewController(hostController, animated: true)
    }
}

extension AuthCoordinator: LoginViewNavigationDelegate {
    func onUserLoginSuccess(userSession: UserSession) {
        
    }
}
