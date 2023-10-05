//
//  ScreenShotManager.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import Foundation
import SwiftUI

class ScreenshotManager: ObservableObject {
    @Published var screenshotTaken: Bool = false
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(detectScreenshot),
                                               name: UIApplication.userDidTakeScreenshotNotification,
                                               object: nil)
    }
    
    @objc func detectScreenshot() {
        screenshotTaken = true
    }
}

