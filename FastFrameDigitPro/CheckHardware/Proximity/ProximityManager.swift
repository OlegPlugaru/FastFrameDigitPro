//
//  ProximityManager.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import Foundation
import Combine
import UIKit

final class ProximityManager: ObservableObject {
    @Published var isNear: Bool = false
     var cancellableSet: Set<AnyCancellable> = []
    private var timer: Timer?
    @Published var testPassed: Bool = false

    init() {
        NotificationCenter.default
            .publisher(for: UIDevice.proximityStateDidChangeNotification)
            .sink { [weak self] _ in
                self?.isNear = UIDevice.current.proximityState
                if self?.isNear == true {
                    self?.startTimer()
                } else {
                    self?.stopTimer()
                }
            }
            .store(in: &cancellableSet)
    }

    func startProximitySensor() {
        UIDevice.current.isProximityMonitoringEnabled = true
    }

    func stopProximitySensor() {
        UIDevice.current.isProximityMonitoringEnabled = false
    }

     func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            self?.stopProximitySensor()
            DispatchQueue.main.async {
                self?.testPassed = true
            }
        }
    }

     func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

final class ProximityManagerTest: ObservableObject {
    @Published var isNear: Bool = false
    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        NotificationCenter.default
            .publisher(for: UIDevice.proximityStateDidChangeNotification)
            .sink { [weak self] _ in
                self?.isNear = UIDevice.current.proximityState
            }
            .store(in: &cancellableSet)
    }

    func startProximitySensor() {
        UIDevice.current.isProximityMonitoringEnabled = true
    }

    func stopProximitySensor() {
        UIDevice.current.isProximityMonitoringEnabled = false
    }
}
