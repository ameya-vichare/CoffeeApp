//
//  FakeCoffeeModuleRemoteAPI.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import Combine
import AppModels
import Networking

public final class FakeCoffeeModuleRemoteAPI: RemoteAPI {
    public init () {}
    
    public func getOrders(config: APIConfig) -> Future<[Coffee], NetworkError> {
        return Future<[Coffee], NetworkError> { [weak self] promise in
            promise(.success(
                [
                    Coffee(id: 1, userName: "Ameya", type: .cappuccino, size: .medium, extras: "Blah", status: .ready, createdAt: "2025-09-13T09:13:15.732796+00:00"),
                    Coffee(id: 2, userName: "Aanchal", type: .latte, size: .small, extras: "Blah", status: .preparing, createdAt: "2025-09-13T09:13:15.732796+00:00")
                ]
            ))
        }
    }
}
