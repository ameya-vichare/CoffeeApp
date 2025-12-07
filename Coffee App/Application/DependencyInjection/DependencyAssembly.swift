//
//  DependencyAssembly.swift
//  Coffee App
//
//  Created by Ameya on 10/10/25.
//

import Resolver

/// Protocol for dependency assemblies, similar to Swinject's Assembly pattern
protocol DependencyAssembly {
    func assemble(container: Resolver)
}

