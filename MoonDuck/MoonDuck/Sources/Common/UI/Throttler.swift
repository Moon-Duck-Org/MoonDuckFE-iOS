//
//  Throttler.swift
//  MoonDuck
//
//  Created by suni on 7/4/24.
//

import Foundation

class Throttler {
    private let queue: DispatchQueue
    private var workItem: DispatchWorkItem?
    private var previousRun: Date?
    private var interval: TimeInterval

    init(interval: TimeInterval, queue: DispatchQueue = .main) {
        self.interval = interval
        self.queue = queue
        self.previousRun = nil
    }

    func throttle(action: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem { [weak self] in
            self?.previousRun = Date()
            action()
        }

        if let previousRun = previousRun {
            let timeSinceLastRun = Date().timeIntervalSince(previousRun)
            let delay = max(0, interval - timeSinceLastRun)
            queue.asyncAfter(deadline: .now() + delay, execute: workItem!)
        } else {
            previousRun = Date()
            queue.async(execute: workItem!)
        }
    }
}
