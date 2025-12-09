//
//  MenuListAssembly.swift
//  Coffee App
//
//  Created by Ameya on 10/10/25.
//

import Resolver
import CoffeeModule
import Networking
import Persistence
import NetworkMonitoring

struct MenuListAssembly: DependencyAssembly {
    func assemble(using resolver: Resolver) {
        // OrderModuleRemoteAPI
        resolver.register { (resolver: Resolver) -> OrderModuleRemoteAPI in
            OrderModuleRemoteAPI(
                networkService: resolver.resolve(NetworkService.self)
            )
        }
        
        // OrderModuleClientRepository
        resolver.register { (resolver: Resolver) -> OrderModuleClientRepository in
            OrderModuleClientRepository(
                remoteAPI: resolver.resolve(OrderModuleRemoteAPI.self),
                dataStore: OrderModuleCoreDataStore(
                    container: resolver.resolve(PersistentContainerProvider.self).container
                )
            )
        }
        
        // Register OrderModuleClientRepository as OrderModuleRepositoryProtocol
        resolver.register { (resolver: Resolver) -> OrderModuleRepositoryProtocol in
            resolver.resolve(OrderModuleClientRepository.self)
        }
        
        // GetMenuUsecase
        resolver.register { (resolver: Resolver) -> GetMenuUsecase in
            GetMenuUsecase(
                repository: resolver.resolve(OrderModuleRepositoryProtocol.self)
            )
        }
        
        // CreateOrderUsecase
        resolver.register { (resolver: Resolver) -> CreateOrderUsecase in
            CreateOrderUsecase(
                repository: resolver.resolve(OrderModuleRepositoryProtocol.self),
                networkMonitor: resolver.resolve(NetworkMonitoring.self)
            )
        }
        
        // RetryPendingOrdersUsecase
        resolver.register { (resolver: Resolver) -> RetryPendingOrdersUsecase in
            RetryPendingOrdersUsecase(
                repository: resolver.resolve(OrderModuleRepositoryProtocol.self)
            )
        }
        
        // MenuModifierBottomSheetPriceComputeUsecase
        resolver.register { MenuModifierBottomSheetPriceComputeUsecase() }
        
        // MenuModifierBottomSheetCreateOrderUseCase
        resolver.register { MenuModifierBottomSheetCreateOrderUseCase() }
    }
}


