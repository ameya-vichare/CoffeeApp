//
//  NetworkMonitor.swift
//  NetworkMonitoring
//
//  Created by Ameya on 06/11/25.
//

import Network
import Combine

public class NetworkMonitor: NetworkMonitoring, @unchecked Sendable {
    public var status: NetworkStatus = .unknown
    private var isMonitoring: Bool = false
    
    let monitor = NWPathMonitor()
    let monitorQueue = DispatchQueue(label: "nw.network.monitor")
    
    private let monitoringSubject = PassthroughSubject<NetworkStatus, Never>()
    
    public var monitoringPublisher: AnyPublisher<NetworkStatus, Never> {
        monitoringSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    public init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            self.updateStatus(for: path.status)
        }
    }
    
    private func updateStatus(for nwStatus: NWPath.Status) {
        status = (nwStatus == .satisfied ? .available : .unavailable)
        monitoringSubject.send(status)
    }

    public func start() {
        guard !isMonitoring else { return }
        isMonitoring = true
        monitor.start(queue: monitorQueue)
        updateStatus(for: monitor.currentPath.status)
    }

    public func stop() {
        guard isMonitoring else { return }
        isMonitoring = false
        monitor.cancel()
    }
}
