//
//  NetworkMonitor.swift
//  AutoTrader
//
//  Created by An Bảo on 27/04/2024.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor = NWPathMonitor()
    
    private var isConnected = false
    
    private init() {}
    
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
    }
    
    func isNetworkConnected() -> Bool {
        return isConnected
    }
}
