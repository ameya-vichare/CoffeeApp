//
//  ImageLoadingAssembly.swift
//  Coffee App
//
//  Created by Ameya on 10/10/25.
//

import Resolver
import ImageLoading
import NetworkMonitoring
import Persistence

struct CoreServicesAssembly: DependencyAssembly {
    func assemble(container: Resolver) {
        container.register { SDWebImageService() as ImageService }
            .scope(.shared)
        container.register { NetworkMonitor() as NetworkMonitoring }
            .scope(.shared)
        container.register { PersistentContainerProvider(modelName: "AppModel") }
            .scope(.shared)
    }
}

