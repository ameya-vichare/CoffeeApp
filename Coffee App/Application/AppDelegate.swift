//
//  AppDelegate.swift
//  Coffee App
//
//  Created by Ameya on 22/11/25.
//

import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let appDIContainer = AppDIContainer()
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationVC = UINavigationController()
        navigationVC.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = navigationVC
        
        let coordinator = AppFlowCoordinator(
            navigationController: navigationVC,
            dependencyContainer: appDIContainer
        )
        coordinator.start()
        
        window?.makeKeyAndVisible()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }
}
