//
//  ChargerView.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//


import SwiftUI
import UIKit

struct ChargerView: View {
    @ObservedObject var vm: ContentModel
    @ObservedObject var vmTest: CheckHardwareVM
    @State private var batteryState: UIDevice.BatteryState = UIDevice.current.batteryState
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
                    .padding(.top, 50)
                    .padding(.bottom, 50)
                Text(vmTest.coordinator.currentView.viewText)
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.97, green: 0.98, blue: 0.99))
                    .padding(.bottom, 30)
                Text("You have \(vmTest.countdown) sec for action, If the charger don't work, swipe left")
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
                Button {
                        vmTest.coordinator.navigateTo(to: .chargerFailed)
                        vmTest.chargerTestPassed = false
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
                            vmTest.coordinator.navigateTo(to: .chargerFailed)
                            vmTest.chargerTestPassed = false
                            vmTest.countdownTimer?.invalidate()
                        }
                    }
            )
        }
        .onAppear {
            vmTest.restartCountdownTimer()
            UIDevice.current.isBatteryMonitoringEnabled = true
        }
        .onDisappear {
            UIDevice.current.isBatteryMonitoringEnabled = false
        }
        .onReceive(timer) { _ in
            batteryState = UIDevice.current.batteryState
            if batteryState != .unplugged  {
               // DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ) {
                    vmTest.coordinator.navigateTo(to: .chargerPassed)
            //    }
            }
        }
    }
}



