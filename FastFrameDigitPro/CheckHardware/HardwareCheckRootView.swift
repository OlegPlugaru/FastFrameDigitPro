//
//  HardwareCheckRootView.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import SwiftUI

struct HardwareCheckRootView: View {
    @StateObject var coordinator: HardwareCheckCoordinator
    @Binding var isShowTab: Bool
    
    var body: some View {
        switch coordinator.currentView {
        case .firstView:
            CheckHardwareView(vm: coordinator.contentViewModel, vmTest: coordinator.checkHardwareViewModel, isShowTab: $isShowTab )
               
        case .buttonUp:
            ButtonView(vm: coordinator.contentViewModel, vmTest: coordinator.checkHardwareViewModel)
            
        case .buttonDown:
            ButtonView(vm: coordinator.contentViewModel,vmTest: coordinator.checkHardwareViewModel)
                
        case .screenshot:
            ButtonView(vm: coordinator.contentViewModel,vmTest: coordinator.checkHardwareViewModel)
        case .buttonPassed:
            TestPassedView(vm: coordinator.contentViewModel,vmTest: coordinator.checkHardwareViewModel)
        case .buttonFailed:
            TestFailedView(vm: coordinator.contentViewModel,vmTest: coordinator.checkHardwareViewModel)
        case .vibration:
            VibrationView(vmTest: coordinator.checkHardwareViewModel, vm: coordinator.contentViewModel)
        case .vibrationGuess:
            VibrationGuess(vmTest: coordinator.checkHardwareViewModel, vm: coordinator.contentViewModel)
        case .vibrationPassed:
            TestPassedView(vm: coordinator.contentViewModel,vmTest: coordinator.checkHardwareViewModel)
        case .vibrationFailed:
            TestFailedView(vm: coordinator.contentViewModel,vmTest: coordinator.checkHardwareViewModel)
        case .proximity:
            ProximitySensor(vm: coordinator.contentViewModel,vmTest: coordinator.checkHardwareViewModel)
        case .proximityPassed:
            TestPassedView(vm: coordinator.contentViewModel,vmTest: coordinator.checkHardwareViewModel)
        case .proximityFailed:
            TestFailedView(vm: coordinator.contentViewModel,vmTest: coordinator.checkHardwareViewModel)
        case .charger:
            ChargerView(vm: coordinator.contentViewModel,vmTest: coordinator.checkHardwareViewModel)
        case .chargerPassed:
            TestPassedView(vm: coordinator.contentViewModel,vmTest: coordinator.checkHardwareViewModel)
        case .chargerFailed:
            TestFailedView(vm: coordinator.contentViewModel,vmTest: coordinator.checkHardwareViewModel)
        case .hardwareResults:
            HardareResults(vmTest: coordinator.checkHardwareViewModel, isShowTab: $isShowTab, vm: coordinator.contentViewModel)
        }
    }
}

