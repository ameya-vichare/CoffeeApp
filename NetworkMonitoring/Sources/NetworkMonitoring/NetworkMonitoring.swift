
import Network
import Combine

public enum NetworkStatus {
    case available
    case unavailable
}

public protocol NetworkMonitoring {
    var status: NetworkStatus { get }
    
    func start()
    func stop()
}

public actor NetworkMonitor: @preconcurrency NetworkMonitoring {
    public var status: NetworkStatus = .unavailable
    private var isMonitoring: Bool = false
    
    let monitor = NWPathMonitor()
    let monitorQueue = DispatchQueue(label: "nw.network.monitor")
    
    private let monitoringSubject = PassthroughSubject<NetworkStatus, Never>()
    
    public var monitoringPublisher: AnyPublisher<NetworkStatus, Never> {
        monitoringSubject
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            Task {
                await self.updateStatus(for: path.status)
            }
        }
    }
    
    private func updateStatus(for nwStatus: NWPath.Status) {
        if nwStatus == .satisfied {
            status = .available
        } else {
            status = .unavailable
        }
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

