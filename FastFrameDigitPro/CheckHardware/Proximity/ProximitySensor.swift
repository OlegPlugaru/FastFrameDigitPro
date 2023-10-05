//
//  ProximitySensor.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import SwiftUI

struct ProximitySensor: View {
    @ObservedObject var vm: ContentModel
    @ObservedObject var vmTest: CheckHardwareVM
    @ObservedObject private var proximityManager = ProximityManagerTest()
    @State private var isProximityTestPassing = false
    
    var body: some View {
        ZStack {
            customBackgroundGradient()
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        vmTest.coordinator.navigateTo(to: .firstView)
                        vm.isTabBarVisible = true
                        vmTest.successTestCount = 0
                        vmTest.successTestCount = 0.0
                        vmTest.buttonsTestPassed = false
                        vmTest.vibrationTestPassed = false
                        vmTest.chargerTestPassed = false
                        vmTest.proximityTestPassed = false
                        vmTest.vibrationCount = 0
                        vmTest.testPassed = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size:  UIScreen.main.bounds.height > 680 ? 20  : 16))
                            .padding(UIScreen.main.bounds.height > 680 ? 12  : 8)
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
                Image(vmTest.coordinator.currentView.imageName)
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
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.97, green: 0.98, blue: 0.99))
                    .padding(.bottom, 30)
                Text("You have \(vmTest.countdown) sec for action, If the proximity sensor don't work, swipe left")
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
                Button {
                    vmTest.coordinator.navigateTo(to: .proximityFailed)
                    vmTest.proximityTestPassed = false
                    vmTest.countdownTimer?.invalidate()
                } label: {
                    Image("swipe")
                }
                Spacer()
            }
            .gesture(
                DragGesture(minimumDistance: 10, coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.width < 0 {
                            vmTest.coordinator.navigateTo(to: .proximityFailed)
                            vmTest.proximityTestPassed = false
                            vmTest.countdownTimer?.invalidate()
                        }
                    }
            )
        }
        .onAppear {
            proximityManager.startProximitySensor()
            vmTest.restartCountdownTimer()
        }
        .onDisappear {
            proximityManager.stopProximitySensor()
            
        }
        .onChange(of: proximityManager.isNear) { newValue in
            if newValue {
                // If proximity is detected, wait for 2 seconds before passing the test
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    isProximityTestPassing = true
                    
                    vmTest.navigateTo(to: .proximityPassed)
                }
            } else {
                
                isProximityTestPassing = false
                if isProximityTestPassing == false {
                    vmTest.navigateTo(to: .proximityFailed)
                }
            }
        }
    }
}


