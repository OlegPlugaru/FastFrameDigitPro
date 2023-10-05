//
//  SpeedChecker.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 14.08.2023.
//

import Foundation
import UIKit
import SpeedcheckerSDK
import CoreLocation

class SpeedChecker: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published private var internetTest: InternetSpeedTest?
    var locationManager = CLLocationManager()
    var testIsFinished = false
    @Published var results: SpeedTestResult? = nil
    @Published var jitter: Int = 0
    @Published var latency: Int = 0
    @Published var upload: Double = 0.0
    @Published var download: Double = 0.0
    @Published var ping: Double = 0.0
    @Published var loss: Int = 0
    @Published var action: (()->Void)?
    @Published var serverURL: String? = nil
    @Published var results1:[ConnectionData] = []
    @Published var testsPerformed: Int = UserDefaults.standard.integer(forKey: "TestsPerformed")
    
    func setup() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func runSpeedTestTouched() {
        DispatchQueue.main.async {
            self.resetValues()
            self.internetTest = InternetSpeedTest(delegate: self)
            self.internetTest?.startTest() { (error) in
                if error != .ok {
                    print(error)
                }
            }
            self.testIsFinished = false
        }
    }
    
    func resetValues(){
        jitter = 0
        upload = 0.0
        download = 0.0
        latency = 0
        loss = 0
        ping = 0.0
        serverURL = nil
        results = nil
    }
    
    func forceFinish(){
        internetTest?.forceFinish({ _ in
        })
    }
}

extension SpeedChecker: InternetSpeedTestDelegate {
    func internetTestError(error: SpeedTestError) {
        print(error)
    }
    
    func internetTestFinish(result: SpeedTestResult) {
        DispatchQueue.main.async {
            self.action!()
            self.results = result
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                self.testIsFinished = true
                GlobalSettings.saveData(true, key: "FirstScanUsed")
                GlobalSettings.addToHistory(data: PackageData(download: self.download, upload: self.upload, ping: self.ping, ip: self.results?.ipAddress ?? "", loss: self.loss, isp: self.results?.ispName ?? "", date: Date(timeIntervalSinceNow: 0)), cdArr:self.results1)
            }
        }
        
    }
    
    func internetTestReceived(servers: [SpeedTestServer]) {
        //
    }
    
    func internetTestSelected(server: SpeedTestServer, latency: Int, jitter: Int) {
        if(serverURL.isNil){
            serverURL = server.domain!
        }
        self.latency = latency
        self.jitter = jitter
    }
    
    func internetTestDownloadStart() {
        //
    }
    
    func internetTestDownloadFinish() {
        //
    }
    
    func internetTestDownload(progress: Double, speed: SpeedTestSpeed) {
        download = speed.mbps
        print("Download: \(speed.descriptionInMbps)")
    }
    
    func internetTestUploadStart() {
        //
    }
    
    func internetTestUploadFinish() {
        //
    }
    
    func internetTestUpload(progress: Double, speed: SpeedTestSpeed) {
        upload = speed.mbps
        print("Upload: \(speed.descriptionInMbps)")
    }
}

extension Optional {
  var isNil: Bool {
    return self == nil
  }
  
  var isNotNil: Bool {
    return self != nil
  }
  
  func ifLet(_ action: (Wrapped)-> Void) {
    if self != nil {
      action(self.unsafelyUnwrapped)
    }
    else { return }
  }
  
  func ifNil (_ action: ()-> Void) {
    if self == nil { action() }
    else { return }
  }
  
  func ifElse(_ notNil: ()-> Void, _ isNil: ()-> Void) {
    if self != nil { notNil() }
    else { isNil() }
  }
  
  func or<T>(_ opt: T) -> T {
    if self == nil { return opt }
    else { return self as! T }
  }
  
  mutating func orChange<T>(_ opt: T) {
    if self == nil { self = opt as? Wrapped }
  }
}
