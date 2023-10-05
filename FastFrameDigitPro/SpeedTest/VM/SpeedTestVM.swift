//
//  SpeedTestVM.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 14.08.2023.
//

import Foundation
import SwiftUI
//import FGRoute
import CoreLocation
import UIKit
import WebKit
import SystemConfiguration
import Network
import StoreKit

class SpeedTestVM: ObservableObject {
    @Published var progress: CGFloat = 0.01
    @Published var goToResult = false
    @Published var isFlying = false
    var coordinator: SpeedTestCoordinator
    
    init(coordinator: SpeedTestCoordinator) {
        self.coordinator = coordinator
    }
    
    func animateLoader(animationDuration: Double) {
        let initialProgress: CGFloat = 0.01
        self.progress = initialProgress
        let animationInterval: Double = 0.01
        let totalSteps = Int(animationDuration / animationInterval)
        print(totalSteps)
        for step in 1...totalSteps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(step) * animationInterval) {
                self.progress = CGFloat(step) / CGFloat(totalSteps)
            }
        }
    }
    
    func calculateRocketXPosition() -> CGFloat {
        // Calculate the X position of the rocket based on the progress
        return  (UIScreen.main.bounds.width - (UIDevice.current.userInterfaceIdiom == .pad ? 180 : 80))  * progress
    }
    
    func resetProgress() {
        progress = 0.01
    }
    
    func startTest(locationManager: CLLocationManager) {
        locationManagerDidChangeAuthorization(locationManager, completionHandler:  {
            if($0) {
                DispatchQueue.main.async {
                    self.isFlying = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    if self.isFlying {
                        self.navigateTo(to: .result)
                    }
                }
            }
        })
    }
    func cancel() {
        DispatchQueue.main.async {
            self.isFlying = false
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager, completionHandler: @escaping (Bool) -> Void) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("enabled")
            completionHandler(true)
            break
        case .restricted, .denied:
            print("disabled")
            showLocationAccessAlert(completionHandler: completionHandler)
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        default:
            showLocationAccessAlert(completionHandler: completionHandler)
        }
    }
    
    func showLocationAccessAlert(completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(
            title: "Location Access Required",
            message: "To use this feature, please enable location access in the Settings app.",
            preferredStyle: .alert
        )
        let settingsAction = UIAlertAction(
            title: "Open Settings",
            style: .default
        ) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        ) { _ in
            completionHandler(false)
        }
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
            topViewController.present(alert, animated: true, completion: nil)
        }
    }
}

func pingServer(url:String, completion: @escaping (Double, Int, Bool)->Void){
    var attemp = 0
    let once = try? SwiftyPing(host: url ,
                               configuration: PingConfiguration(interval: 0.4, with: 5),
                               queue: DispatchQueue.global())
    once?.observer = { (response) in
        let duration = response.duration
        completion(duration,0,false)
        if attemp >= 19 {
            once?.stopPinging()
        }
        attemp+=1
    }
    once?.finished = { results in
        print(results.responses.count)
        completion(results.roundtrip?.average ?? 0.0,(results.responses.count/20-1)*100, true)
    }
    try? once?.startPinging()
}

typealias SpeedTestVMNavigation = SpeedTestVM
extension SpeedTestVMNavigation {
    func navigateTo(to view: SpeedTestViewsEnum) {
        withAnimation(.easeOut(duration: 0.3)) {
            DispatchQueue.main.async {
                self.coordinator.navigateTo(to: view)
            }
        }
    }
}
