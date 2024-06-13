import Foundation
import Network

struct NetworkStatusManager {
    static let shared = NetworkStatusManager()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    var isDeviceOnline: Bool {
        switch currentStatus() {
        case .connected: return true
        case .noConnection, .requiresConnection, .unknown: return false
        }
    }
        
    init() { monitor = NWPathMonitor() }
    
    private func currentStatus() -> FLCNetworkingAvailabilityStatus {
        var status: FLCNetworkingAvailabilityStatus
        
        switch monitor.currentPath.status {
        case .satisfied: status = .connected
        case .unsatisfied: status = .noConnection
        case .requiresConnection: status = .requiresConnection
        @unknown default: status = .unknown
        }
        return status
    }
    func startMonitoring() { monitor.start(queue: queue) }
    func stopMonitoring() { monitor.cancel() }
}
