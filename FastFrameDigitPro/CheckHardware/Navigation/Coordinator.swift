//
//  Coordinator.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//


import Foundation
import SwiftUI

class HardwareCheckCoordinator: ObservableObject {
    @Published var currentView: HardwareCheckViewsEnum = .firstView
    @Published var contentViewModel: ContentModel!
    @Published var checkHardwareViewModel: CheckHardwareVM!
    
    init(contentViewModel: ContentModel) {
        self.contentViewModel = contentViewModel
        self.checkHardwareViewModel = CheckHardwareVM(coordinator: self)
    }
}

//MARK: - Navigation methods
typealias HardwareCheckCoordinatorNavigation = HardwareCheckCoordinator
extension HardwareCheckCoordinatorNavigation {
    func navigateTo(to view: HardwareCheckViewsEnum) {
        DispatchQueue.main.async {
            self.currentView = view
        }
    }
}

enum HardwareCheckViewsEnum {
    case firstView
    case buttonUp
    case buttonDown
    case screenshot
    case buttonPassed
    case buttonFailed
    case vibration
    case vibrationGuess
    case vibrationPassed
    case vibrationFailed
    case proximity
    case proximityPassed
    case proximityFailed
    case charger
    case chargerPassed
    case chargerFailed
    case hardwareResults
    
    var viewName: String {
        switch self {
        case .firstView, .hardwareResults:
            return "Hardware test"
        case .buttonUp, .buttonDown, .screenshot, .buttonPassed, .buttonFailed:
            return "Buttons"
        case .vibration, .vibrationGuess,.vibrationPassed, .vibrationFailed:
            return "Vibration"
        case .proximity, .proximityPassed, .proximityFailed:
            return "Proximity Sensor"
        case .charger, .chargerPassed, .chargerFailed:
            return "Charger"
        }
    }
    
    var imageName: String {
        switch self {
        case .firstView, .hardwareResults:
            return "deviceQuestion"
        case .buttonUp:
            return "volumeUP"
        case .buttonDown:
            return "volumeDown"
        case .screenshot:
            return "screenshot"
        case .buttonPassed, .vibrationPassed, .proximityPassed, .chargerPassed:
            return "Passed"
        case .buttonFailed, .vibrationFailed, .proximityFailed, .chargerFailed:
            return "failed"
        case .vibration, .vibrationGuess:
            return "phone"
        case .proximity:
            return "hand"
        case .charger:
           return "charger"
        }
    }
    
    var viewText: String {
        switch self {
        case .firstView, .hardwareResults:
            return "There’s no information about your device hardware yet."
        case .buttonUp:
            return "Press the volume up button."
        case .buttonDown:
            return "Press the volume down button."
        case .screenshot:
            return "Take a Screenshot"
        case .buttonPassed, .buttonFailed:
            return "Button"
        case .vibration:
            return "Count the number of vibrations."
        case .vibrationGuess:
            return "How many times did the device vibrate?"
        case .vibrationPassed, .vibrationFailed:
            return "Vibration"
        case .proximity:
            return "Place your hand on top of the device covering the front camera."
        case .proximityPassed, .proximityFailed:
            return "Proximity Sensor"
        case .charger:
            return "Connect your charger. Please make sure it’s connected to a power outlet."
        case .chargerPassed, .chargerFailed:
            return "Charger"
        }
    }
}

