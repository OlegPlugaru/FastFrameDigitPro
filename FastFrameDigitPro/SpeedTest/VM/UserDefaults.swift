//
//  UserDefaults.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import SwiftUI
import Combine
import MapKit
//import IHProgressHUD
import StoreKit


class GlobalSettings:ObservableObject{
    
    static let scan_store_key = "scan_records"
    static let unit_selector = "mesure_performance_in"
    
    static func saveData(_ data: Any, key:String) {
        DispatchQueue.main.async {
            UserDefaults.standard.set(data, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }

    
    static func loadData(key:String) ->  Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    static func removeData(key:String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    static func loadRawEnumVal() -> Int{
        return UserDefaults.standard.integer(forKey:unit_selector)
    }
    
    static func extractFromHistory() -> packDataList? {
        
            let response = UserDefaults.standard.object(forKey: scan_store_key)
            
            if(response.isNotNil){
                
                if let data = UserDefaults.standard.object(forKey: scan_store_key) as? Data,
                   let allrecords = try? JSONDecoder().decode(packDataList.self, from: data) {
 
                    return allrecords
                }
                return packDataList(records: [])
                
            }
            return nil
    }
    static func addToHistory(data: PackageData, cdArr: [ConnectionData]){
        DispatchQueue.main.async {
            var allrecords = extractFromHistory()
            
            var pack = simplifiedPackData(
                upload: Double(data.upload),
                download: Double(data.download),
                ping: Double(data.ping),
                ip: data.ip,
                loss: data.loss,
                isp: data.isp,
                date: String(data.date.timeIntervalSince1970),
                networkData: []
            )
            for cd in cdArr {
                pack.networkData.append(LightConnData(param: cd.param, value: cd.value))
            }
            
            if(allrecords.isNil || (allrecords?.records.count)! == 0){
                
                allrecords = packDataList.init(records: [pack])
                
            } else {
                allrecords?.records.append(pack)
            }
            
            if let en_allrecords = try? JSONEncoder().encode(allrecords){
                UserDefaults.standard.set(en_allrecords, forKey: scan_store_key)
            }
            
            UserDefaults.standard.synchronize()
            
        }
    }
    
    static func clearHistory(){
        DispatchQueue.main.async {
            UserDefaults.standard.set(nil,forKey: scan_store_key)
            UserDefaults.standard.synchronize()
        }
    }
}

struct packDataList : Codable{
    var records: [simplifiedPackData]
}

struct simplifiedPackData: Codable {
    let upload: Double
    let download: Double
    let ping: Double
    let ip: String
    let loss: Int
    let isp: String
    let date: String
    var networkData: [LightConnData]
}

struct ConnectionData: Hashable{
    init(param: String, value: String, quality: qualityLvls? = nil) {
        self.param = param
        self.value = value
        self.quality = quality
    }
    let param: String
    let value: String
    var quality: qualityLvls? = nil
}



struct PackageData:Identifiable, Hashable{
    var id = UUID()
    var download: Double
    var upload: Double
    var ping: Double
    let ip: String
    var loss: Int
    var isp : String
    var date: Date
}

struct LightConnData: Codable{
    let param: String
    let value: String
}


enum qualityLvls: Comparable, Codable{
    case bad, low, mid, good, great
    
    static var allCases: [qualityLvls] {
        return [.bad, .low, .mid, .good, .great]
        }
}
