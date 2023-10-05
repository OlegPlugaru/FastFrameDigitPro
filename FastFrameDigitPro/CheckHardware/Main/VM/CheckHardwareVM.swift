//
//  CheckHardwareVM.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import SwiftUI
import Combine

class CheckHardwareVM: ObservableObject {
    private var cancelables: Set<AnyCancellable> = []
    var coordinator: HardwareCheckCoordinator
    @Published var volumeUP = false
    @Published var volumeUpPassed = false
    @Published var volumeDown = false
    @Published var screenShot = false
    @Published var startTest = false
    @Published var volumeDownPassed = false
    @Published var screenshotPassed = false
    @Published var vibrationCount: Int = 0
    @Published var testPassed: Bool = false
    @Published var buttonsTestPassed = false
    @Published var vibrationTestPassed = false
    @Published var proximityTestPassed = false
    @Published var chargerTestPassed = false
    @Published var successTestCount = 0.0
    @Published var countdown = 20
    @Published var countdownTimer: Timer?
    @Published var initialCountdown = 20
    private var randomNumbers: Set<Int> = []
    @Published var isVibrationRunning = false
    private var vibrationCancellable: AnyCancellable?
    
    init(coordinator: HardwareCheckCoordinator) {
        self.coordinator = coordinator
    }
}

//MARK: - Navigation
typealias CheckHardwareVMNavigation = CheckHardwareVM
extension CheckHardwareVMNavigation {
    func navigateTo(to view: HardwareCheckViewsEnum) {
            coordinator.navigateTo(to: view)
    }
    
    func generateRandomButtonNumbers(vibrationCount: Int) -> [Int] {
        var numbers = [Int]()
        
        // Generate two random numbers
        while numbers.count < 2 {
            let randomNum = Int.random(in: 1..<10) // Adjust the range as needed
            if !numbers.contains(randomNum) {
                numbers.append(randomNum)
            }
        }
        
        // Add the vibration count as one of the numbers
        numbers.append(vibrationCount)
        
        // Shuffle the numbers to randomize their order
        numbers.shuffle()
        
        return numbers
    }
    
    func giveRandomVibrationNumber() {
        if isVibrationRunning {
            return // Don't start another vibration if one is already running
        }
        
        isVibrationRunning = true
        
        DispatchQueue.global().async {
            let randomVibrations = Int.random(in: 3...9)
            for _ in 1...randomVibrations {
                if !self.isVibrationRunning {
                    break // Stop the vibration if isVibrationRunning becomes false
                }
                
                HapticManager.instance.notification(type: .error)
                DispatchQueue.main.async {
                    self.vibrationCount += 1
                }
                Thread.sleep(forTimeInterval: 1)
            }
            
            // Check if isVibrationRunning is still true before navigating
            if self.isVibrationRunning {
                self.navigateTo(to: .vibrationGuess)
            }
            
            print("Total vibrations executed: \(self.vibrationCount)")
            
            DispatchQueue.main.async {
                self.isVibrationRunning = false
            }
        }
    }

    
    func checkResult() -> Bool {
        var result: Bool = false
        if volumeUpPassed && volumeDownPassed && screenshotPassed {
            result = true
        } else if !volumeUpPassed || volumeDownPassed || screenshotPassed {
            result = false
        }
        return result
    }

 
    
    func calculateSuccessPercentage() -> Double {
        let result = self.successTestCount / 4 * 100
        return result
    }
    
     func startCountdownTimer() {
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.countdown > 0 {
                self.countdown -= 1
            } else {
                timer.invalidate()
                if self.coordinator.currentView == .buttonUp {
                    self.navigateTo(to: .buttonDown)
                    self.volumeUpPassed = false
                    self.restartCountdownTimer()
                } else if self.coordinator.currentView == .buttonDown {
                    self.navigateTo(to: .screenshot)
                    self.volumeDownPassed = false
                    self.restartCountdownTimer()
                } else if self.coordinator.currentView == .screenshot {
                    self.navigateTo(to: .buttonFailed)
                    self.screenshotPassed = false
                } else if self.coordinator.currentView == .proximity {
                    self.navigateTo(to: .proximityFailed)
                    self.proximityTestPassed = false
                } else if self.coordinator.currentView == .charger {
                    self.navigateTo(to: .chargerFailed)
                    self.chargerTestPassed = false
                }
            }
        }
    }
    
    func restartCountdownTimer() {
        self.countdown = self.initialCountdown
        startCountdownTimer()
    }
}

