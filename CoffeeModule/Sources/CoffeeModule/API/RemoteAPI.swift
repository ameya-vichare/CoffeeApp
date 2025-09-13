//
//  RemoteAPI.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import Combine
import AppModels
import Networking

protocol RemoteAPI {
    func getOrders(config: APIConfig) -> Future<[Coffee], NetworkError>
}
