//
//  ContentBlockerRequestHandler.swift
//  Advertisments
//
//  Created by Oleg Plugaru on 05.10.2023.
//

import UIKit
import MobileCoreServices


class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let attachment = NSItemProvider(contentsOf: Bundle.main.url(forResource: "blockerList", withExtension: "json"))!
        
        let item = NSExtensionItem()
        item.attachments = [attachment]
        
        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
    
    func getBlockList() -> [Any] {
        
        let defaults = UserDefaults(suiteName: "group.com.unicalauto.contentblocker")
        
        let blackData = defaults?.value(forKey: "blackList")
        let blackList = blackData as? [Dictionary<String, Any>] ?? []
        
        let adultData = defaults?.value(forKey: "adultList")
        let adultList = adultData as? [Dictionary<String, Any>] ?? []
        
        let gamblingData = defaults?.value(forKey: "gamblingList")
        let gamblingList = gamblingData as? [Dictionary<String, Any>] ?? []
        
        let unsafeData = defaults?.value(forKey: "unsafeList")
        let unsafeList = unsafeData as? [Dictionary<String, Any>] ?? []
        
        let defaultData = (try? Data(contentsOf: Bundle.main.url(forResource: "blockerList", withExtension: "json")!))!
        let defaultList = try? JSONSerialization.jsonObject(with: defaultData, options: .allowFragments) as? [Dictionary<String, Any>]
        
        let blockList = defaultList! + blackList + adultList + gamblingList + unsafeList
        return blockList
    }
}
