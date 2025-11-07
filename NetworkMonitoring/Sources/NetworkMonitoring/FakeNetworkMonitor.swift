//
//  FakeNetworkMonitor.swift
//  NetworkMonitoring
//
//  Created by Ameya on 06/11/25.
//

import Network
import Combine

public class FakeNetworkMonitor: NetworkMonitoring {
    public var status: NetworkStatus = .available
    public var monitoringPublisher: AnyPublisher<NetworkStatus, Never> {
        PassthroughSubject<NetworkStatus, Never>()
            .eraseToAnyPublisher()
    }
    
    public init() {
        
    }

    public func start() {
    }

    public func stop() {
    }
}
