import Foundation
import Network

struct NetworkAvailabilityManager {
    static let shared = NetworkAvailabilityManager()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    init() { monitor = NWPathMonitor() }
    
    func currentStatus() -> FLCNetworkingAvailabilityStatus {
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
