//
//  WifiVM.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import SwiftUI
import Network

import Foundation

struct LocationModel: Codable {
    let country_name: String
    let state_prov: String
    let city: String
    let time_zone: TimeZoneInfo
    let longitude: String
    let isp: String
    let connection_type: String
    
    struct TimeZoneInfo: Codable {
        let offset: Int
    }
}

class LocationVM: ObservableObject {
    @Published var toFetchIP: String = ""
    @Published var fetchedLocation: LocationModel?
    @Published var timeZoneOffsetString: String = ""
    @Published var connectionType: String = "Unknown"
    @Published var usersIP: String = "Loading..."
    @Published var deviceIp: String = ""
    @Published var providerName: String = "Loading..."
    
    init() {
        fetchUserIP()
        setupNetworkMonitoring()
        fetchExternalIP()
        deviceIp = UIDevice.current.getIP() ?? "Loading..."
    }
    
    func fetchUserIP() {
        guard let url = URL(string: "https://api.ipify.org") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let ipAddress = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.toFetchIP = ipAddress
                }
            }
        }.resume()
    }
    
    func fetchIPInformationUsingAPI(apiKey: String) {
        guard !usersIP.isEmpty, let url = URL(string: "https://api.ipgeolocation.io/ipgeo?apiKey=\(apiKey)&ip=\(usersIP)") else {
            print("something wrong")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let locationInfo = try decoder.decode(LocationModel.self, from: data)
                    DispatchQueue.main.async {
                        self.fetchedLocation = locationInfo
                        self.timeZoneOffsetString = self.formatTimeZoneOffset(offset: locationInfo.time_zone.offset)
                    }
                    print("LOCATION INFO", locationInfo)
                } catch {
                    print("Error decoding location information:", error)
                }
            }
        }.resume()
    }
    
    func formatTimeZoneOffset(offset: Int) -> String {
        let sign = offset >= 0 ? "+" : "-"
        let offsetHours = abs(offset)
        return "UTC \(sign)\(offsetHours)"
    }
    
    private func setupNetworkMonitoring() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if path.usesInterfaceType(.wifi) {
                    self?.connectionType = "Wi-Fi"
                } else if path.usesInterfaceType(.cellular) {
                    self?.connectionType = "Cellular"
                } else {
                    self?.connectionType = "Unknown"
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    func fetchExternalIP() {
        guard let url = URL(string: "https://api.ipify.org?format=json") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let ipData = try? JSONDecoder().decode(IPData.self, from: data) {
                    DispatchQueue.main.async {
                        self.usersIP = ipData.ip
                        self.fetchProviderName()
                    }
                }
            }
        }.resume()
    }
    
    func fetchProviderName() {
        guard let url = URL(string: "https://ipapi.co/\(usersIP)/org") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let providerData = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.providerName = providerData
                    }
                }
            }
        }.resume()
    }
}

struct IPData: Codable {
    let ip: String
}
