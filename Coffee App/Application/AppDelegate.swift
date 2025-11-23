//
//  AppDelegate.swift
//  Coffee App
//
//  Created by Ameya on 22/11/25.
//

import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let appDependencyContainer: AppDIContainer = AppDIContainer()
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = navigationController
        
        let flowCoordinator = AppFlowCoordinator(
            container: appDependencyContainer,
            navigationController: navigationController
        )
        flowCoordinator.start()
        
        window?.makeKeyAndVisible()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }
}
