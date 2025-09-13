//
//  FakeCoffeeModuleRemoteAPI.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import Combine
import AppModels
import Networking

final class FakeCoffeeModuleRemoteAPI: RemoteAPI {
    func getOrders(config: APIConfig) -> Future<[Coffee], NetworkError> {
        return Future<[Coffee], NetworkError> { [weak self] promise in
            promise(.success(
                [
                    Coffee(id: 1, userName: "Ameya", type: .cappuccino, size: .medium, extras: "Blah", status: .ready),
                    Coffee(id: 2, userName: "Aanchal", type: .latte, size: .small, extras: "Blah", status: .preparing)
                ]
            ))
        }
    }
}
