//
//  AssemblyRegistration.swift
//  Coffee App
//
//  Created by Ameya on 09/12/25.
//

import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        let assembly: [DependencyAssembly] = [
            // Core Services
            CoreServicesAssembly(),
            
            // Feature Assemblies
            AuthModuleAssembly(),
            OrderModuleAssembly(),
        ]
        
        assembly.forEach { $0.assemble(using: main) }
    }
}
