import Foundation
import Network

class NetworkStatusManager {
    static let shared = NetworkStatusManager()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    private var currentNetworkStatus: FLCNetworkingAvailabilityStatus = .unknown
    
    var isDeviceOnline: Bool {
        switch currentNetworkStatus {
        case .connected: return true
        case .noConnection, .requiresConnection, .unknown: return false
        }
    }
    
    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.updateNetworkStatus(path: path)
        }
    }
    
    private func updateNetworkStatus(path: NWPath) {
        switch path.status {
        case .satisfied:
            currentNetworkStatus = .connected
        case .unsatisfied:
            currentNetworkStatus = .noConnection
        case .requiresConnection:
            currentNetworkStatus = .requiresConnection
        @unknown default:
            currentNetworkStatus = .unknown
        }
    }
    func startMonitoring() { monitor.start(queue: queue) }
    func stopMonitoring() { monitor.cancel() }
}
