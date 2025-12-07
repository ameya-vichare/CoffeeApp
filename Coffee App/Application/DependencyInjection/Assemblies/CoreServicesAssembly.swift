//
//  CoreServicesAssembly.swift
//  Coffee App
//
//  Created by Ameya on 10/10/25.
//

import Resolver
import ImageLoading
import NetworkMonitoring
import Persistence
import AppCore
import Foundation

struct CoreServicesAssembly: DependencyAssembly {
    func assemble(using resolver: Resolver) {
        // ImageService
        resolver.register { SDWebImageService() as ImageService }
            .scope(.shared)
        
        // NetworkMonitoring
        resolver.register { NetworkMonitor() as NetworkMonitoring }
            .scope(.shared)
        
        // PersistentContainerProvider
        resolver.register { PersistentContainerProvider(modelName: "AppModel") }
            .scope(.shared)
        
        resolver.register { AppConfiguration() }
        
        // NetworkService
        resolver.register { (resolver: Resolver) -> NetworkService in
            let appConfiguration = resolver.resolve(AppConfiguration.self)
            let apiKey = appConfiguration.apiKey
            guard let url = URL(string: appConfiguration.apiBaseURL) else {
                fatalError("Invalid URL: \(appConfiguration.apiBaseURL)")
            }
            
            return NetworkClient(
                baseURL: url,
                defaultHeaders: [
                    "Authorization": "Bearer \(apiKey)"
                ]
            )
        }
        .scope(.shared)
    }
}
