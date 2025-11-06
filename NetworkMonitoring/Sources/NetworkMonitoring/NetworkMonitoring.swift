
import Network
import Combine

public enum NetworkStatus {
    case available
    case unavailable
}

public protocol NetworkMonitoring {
    var status: NetworkStatus { get }
    
    func start() async
    func stop()
}

public actor NetworkMonitor: @preconcurrency NetworkMonitoring {
    
    public var status: NetworkStatus = .unavailable
    
    let monitor = NWPathMonitor()
    let monitorQueue = DispatchQueue(label: "nw.network.monitor")
    
    private let monitoringSubject = PassthroughSubject<NetworkStatus, Never>()
    
    public var monitoringPublisher: AnyPublisher<NetworkStatus, Never> {
        monitoringSubject
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private var isMonitoring: Bool = false
    
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

    public func start() async {
        guard !isMonitoring else { return }
        isMonitoring = true
        monitor.start(queue: monitorQueue)
        await updateStatus(for: monitor.currentPath.status)
    }

    public func stop() {
        guard isMonitoring else { return }
        isMonitoring = false
        monitor.cancel()
    }
}

