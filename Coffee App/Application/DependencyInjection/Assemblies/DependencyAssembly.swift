//
//  DependencyAssembly.swift
//  Coffee App
//
//  Created by Ameya on 10/10/25.
//

import Resolver

protocol DependencyAssembly {
    func assemble(using resolver: Resolver)
}
