
import Combine

public enum NetworkStatus: Sendable {
    case unknown
    case available
    case unavailable
}

public protocol NetworkMonitoring {
    var status: NetworkStatus { get }
    var monitoringPublisher: AnyPublisher<NetworkStatus, Never> { get }
    
    func start()
    func stop()
}
