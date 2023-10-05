//
//  SpeedTestCoordinator.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import Foundation
import SwiftUI

class SpeedTestCoordinator: ObservableObject {
    @Published var currentView: SpeedTestViewsEnum = .animation
    @Published var vm: ContentModel!
    @Published var speedVM: SpeedTestVM!
    @Published var checker: SpeedChecker!
    @Published var disabledTabBar = false
    
    init(vm: ContentModel) {
        self.vm = vm
        self.speedVM = SpeedTestVM(coordinator: self)
        self.checker = SpeedChecker()
    }
}

typealias SpeedTestCoordinatorNavigation = SpeedTestCoordinator
extension SpeedTestCoordinatorNavigation {
    func navigateTo(to view: SpeedTestViewsEnum) {
        DispatchQueue.main.async {
            self.currentView = view
        }
    }
}

enum SpeedTestViewsEnum {
    case animation
    case result
    case history
}

