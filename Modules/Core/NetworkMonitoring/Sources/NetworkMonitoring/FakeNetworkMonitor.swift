//
//  FakeNetworkMonitor.swift
//  NetworkMonitoring
//
//  Created by Ameya on 06/11/25.
//

import Network
import Combine

public class FakeNetworkMonitor: NetworkMonitoring {
    public var status: NetworkStatus
    public var monitoringPublisher: AnyPublisher<NetworkStatus, Never> {
        PassthroughSubject<NetworkStatus, Never>()
            .eraseToAnyPublisher()
    }
    
    public init(status: NetworkStatus = .available) {
        self.status = status
    }

    public func start() {
    }

    public func stop() {
    }
}
