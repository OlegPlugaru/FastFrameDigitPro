//
//  SpeedTestRootView.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import SwiftUI

struct SpeedTestRootView: View {
    @StateObject var coordinator: SpeedTestCoordinator
    
    var body: some View {
        switch coordinator.currentView {
        case .animation:
            SpeedTestView(vm: coordinator.vm, speedMV: coordinator.speedVM, speedChecker: coordinator.checker)
        case .result:
            TestResult(vm: coordinator.vm, speedVM: coordinator.speedVM, speedChecker: coordinator.checker)
        case.history:
            SpeedTestHistory(vm: coordinator.vm, speedVM: coordinator.speedVM)
        }
    }
}
