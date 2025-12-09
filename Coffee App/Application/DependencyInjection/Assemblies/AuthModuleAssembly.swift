//
//  AuthModuleAssembly.swift
//  Coffee App
//
//  Created by Ameya on 10/10/25.
//

import Resolver
import AuthModule
import Networking
import Persistence

struct AuthModuleAssembly: DependencyAssembly {
    func assemble(using resolver: Resolver) {
        // AuthRepository
        resolver.register { (resolver: Resolver) -> AuthRepositoryProtocol in
            let persistentProvider = resolver.resolve(PersistentContainerProvider.self)
            let networkService = resolver.resolve(NetworkService.self)
            return AuthRepository(
                dataStore: AuthModuleCoreDataStore(
                    container: persistentProvider.container
                ),
                remoteAPI: AuthRemoteAPI(networkService: networkService)
            )
        }
        .scope(.application)
        
        // UserLoginUseCase
        resolver.register { (resolver: Resolver) -> UserLoginUseCase in
            UserLoginUseCase(
                repository: resolver.resolve(AuthRepositoryProtocol.self)
            )
        }
        
        // LoginValidationUseCase
        resolver.register { LoginValidationUseCase() }
    }
}

