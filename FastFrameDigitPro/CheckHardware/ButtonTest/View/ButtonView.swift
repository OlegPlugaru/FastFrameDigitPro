//
//  ButtonView.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import SwiftUI
import JPSVolumeButtonHandler

struct ButtonView: View {
    @ObservedObject var vm: ContentModel
    @State var volumeHandler: JPSVolumeButtonHandler?
    @StateObject var screenshotDetector = ScreenshotManager()
    @ObservedObject var vmTest: CheckHardwareVM
    @State private var navigateToNextTest: Bool = false
    @State var showResults = false
    @State var title = "Buttons"
    @State var passed = false
    
    var body: some View {
        ZStack {
            customBackgroundGradient()
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            vmTest.navigateTo(to: .firstView)
                            vm.isTabBarVisible = true
                            vmTest.successTestCount = 0
                            vmTest.successTestCount = 0.0
                            vmTest.buttonsTestPassed = false
                            vmTest.vibrationTestPassed = false
                            vmTest.chargerTestPassed = false
                            vmTest.proximityTestPassed = false
                            vmTest.vibrationCount = 0
                            vmTest.testPassed = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size:  UIScreen.main.bounds.height > 680 ? 20  : 16))
                            .padding(UIScreen.main.bounds.height > 680 ? 12 : 8)
                            .background {
                                Circle()
                                    .fill(LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: Color(red: 0.08, green: 0.08, blue: 0.08), location: 0.00),
                                            Gradient.Stop(color: Color(red: 0.18, green: 0.2, blue: 0.21), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 0.82, y: 0.88),
                                        endPoint: UnitPoint(x: 0.2, y: 0.11)
                                    )
                                    )
                                    .overlay {
                                        Circle()
                                            .inset(by: 1)
                                            .stroke(lineWidth: 1)
                                            .foregroundStyle(LinearGradient(colors: [Color(red: 0.16, green: 0.18, blue: 0.2),.clear ], startPoint: .bottomTrailing, endPoint: .top))
                                    }
                                    .shadow(color: .black.opacity(0.35), radius: 18, x: 7, y: 10)
                            }
                    }
                    .frame(width: 40, alignment: .leading)
                    Spacer()
                    Text(vmTest.coordinator.currentView.viewName)
                        .font(.system(size: UIScreen.main.bounds.height > 680 ? 24  : 20))
                        .foregroundColor(Color(red: 0.97, green: 0.98, blue: 0.99))
                    Spacer()
                    Image(systemName: "xmark")
                        .frame(width: 40)
                        .opacity(0)
                }
                .padding(.horizontal)
                Spacer()
                if vmTest.coordinator.currentView != .screenshot {
                    HStack {
                        Image(vmTest.coordinator.currentView.imageName)
                            .padding(.leading, UIDevice.current.userInterfaceIdiom == .pad ? 227 : 29)
                        Spacer()
                    }
                    .padding(.bottom)
                } else {
                    HStack {
                        Image(vmTest.coordinator.currentView.imageName)
                            .padding(.bottom)
                    }
                }
                Spacer()
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 0.88),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                    ))
                    .padding(.horizontal,UIDevice.current.userInterfaceIdiom == .pad ? 120 : 20)
                Spacer()
                Text(vmTest.coordinator.currentView.viewText)
                    .font(.system(size:  UIScreen.main.bounds.height > 680 ? 16 : 14))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.97, green: 0.98, blue: 0.99))
                    .padding(.bottom)
                Text("You have \(vmTest.countdown) sec for action, If the button don't work, swipe left")
                    .font(.system(size: UIScreen.main.bounds.height > 680 ? 16 : 14))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
                Button {
                    if vmTest.coordinator.currentView == .buttonUp {
                        vmTest.navigateTo(to: .buttonDown)
                        vmTest.volumeUpPassed = false
                        vmTest.countdownTimer?.invalidate()
                        vmTest.restartCountdownTimer()
                    } else if vmTest.coordinator.currentView == .buttonDown {
                        vmTest.navigateTo(to: .screenshot)
                        vmTest.volumeDownPassed = false
                        vmTest.countdownTimer?.invalidate()
                        vmTest.restartCountdownTimer()
                    } else if vmTest.coordinator.currentView == .screenshot {
                        vmTest.navigateTo(to: .buttonFailed)
                        vmTest.screenshotPassed = false
                    }
                } label: {
                    Image("swipe")
                }
                .padding(.bottom)
                Spacer()
            }
            .gesture(
                DragGesture(minimumDistance: 10, coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.width < 0 {
                            if vmTest.coordinator.currentView == .buttonUp {
                                vmTest.navigateTo(to: .buttonDown)
                                vmTest.volumeUpPassed = false
                                vmTest.countdownTimer?.invalidate()
                                vmTest.restartCountdownTimer()
                            } else if vmTest.coordinator.currentView == .buttonDown {
                                vmTest.navigateTo(to: .screenshot)
                                vmTest.volumeDownPassed = false
                                vmTest.countdownTimer?.invalidate()
                                vmTest.restartCountdownTimer()
                            } else if vmTest.coordinator.currentView == .screenshot {
                                vmTest.navigateTo(to: .buttonFailed)
                                vmTest.screenshotPassed = false
                            }
                        }
                    }
            )
        }
        .navigationBarBackButtonHidden(true)
        .task {
            volumeHandler = JPSVolumeButtonHandler(up: {
                vmTest.countdownTimer?.invalidate()
                vmTest.restartCountdownTimer()
                if vmTest.coordinator.currentView == .buttonUp {
                    vmTest.navigateTo(to: .buttonDown)
                    vmTest.volumeUpPassed = true
                    volumeHandler?.start(false)
                }
            }, downBlock: {
                vmTest.countdownTimer?.invalidate()
                vmTest.restartCountdownTimer()
                if vmTest.coordinator.currentView == .buttonDown {
                    vmTest.navigateTo(to: .screenshot)
                    vmTest.volumeDownPassed = true
                    volumeHandler?.start(false)
                }
            })
            volumeHandler?.start(false)
        }
        .onReceive(screenshotDetector.$screenshotTaken) {taken in
            if taken {
                vmTest.screenshotPassed = true
                if vmTest.coordinator.currentView == .screenshot && vmTest.checkResult() {
                    print(vmTest.checkResult())
                    vmTest.navigateTo(to: .buttonPassed)
                } else {
                    vmTest.navigateTo(to: .buttonFailed)
                }
            }
        }
        .onAppear {
            volumeHandler?.start(true)
            vmTest.startCountdownTimer()
        }
        .onDisappear {
            volumeHandler?.start(false)
        }
    }
}



