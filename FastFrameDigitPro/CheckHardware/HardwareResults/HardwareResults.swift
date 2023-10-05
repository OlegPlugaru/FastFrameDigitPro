//
//  HardwareResults.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import Foundation
import SwiftUI

struct HardareResults: View {
    @ObservedObject var vmTest: CheckHardwareVM
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @State var progress: Double = 0.0
    @Binding var isShowTab: Bool
    @ObservedObject var vm: ContentModel
    
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
                ZStack {
                    Circle()
                        .stroke(lineWidth: UIDevice.current.userInterfaceIdiom == .pad ? 40 : 30)
                        .opacity(0.20)
                        .foregroundColor(Color(red: 0.02, green: 0.33, blue: 0.65))
                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(progress / 100.0, 1.0)))
                        .stroke(style: StrokeStyle(lineWidth: UIDevice.current.userInterfaceIdiom == .pad ? 39 : 29, lineCap: .round, lineJoin: .round))
                        .foregroundStyle(LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.8, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        ))
                        .rotationEffect(Angle(degrees: 270))
                        .animation(.linear(duration: 0.2), value: progress)
                    VStack {
                        Text("Works")
                            .foregroundColor(.white)
                        Text(String(format: "%.1f%%", self.progress ))
                            .font(
                                Font.system(size: 22)
                                    .bold())
                            .foregroundColor(Color.white)
                    }
                }
                .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 226 : 186, height:  UIDevice.current.userInterfaceIdiom == .pad ? 226 : 186)
                .padding(.horizontal)
                .padding(.bottom)
                Spacer()
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: UIDevice.current.userInterfaceIdiom == .pad ? 170 : 130)
                    .foregroundColor(.white.opacity(0.2))
                    .blur(radius: 220)
                    .overlay {
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(lineWidth: 2)
                            .foregroundStyle(LinearGradient(colors: [.gray,.clear, .clear], startPoint: .top, endPoint: .bottom))
                    }
                    .cornerRadius(40)
                    .padding(.horizontal,UIDevice.current.userInterfaceIdiom == .pad ? 140 : 16)
                    .overlay(alignment: .top) {
                        VStack(spacing: 30) {
                            HStack {
                                Text("Buttons")
                                    .foregroundColor(.white)
                                Circle()
                                    .frame(width: 8, height: 8)
                                    .foregroundColor(vmTest.buttonsTestPassed ? .green : .red)
                                Spacer()
                                Text("Vibration")
                                    .foregroundColor(.white)
                                Circle()
                                    .frame(width: 8, height: 8)
                                    .foregroundColor(vmTest.vibrationTestPassed ? .green : .red)
                            }
                            HStack {
                                Text("Proximity Sensor")
                                    .foregroundColor(.white)
                                Circle()
                                    .frame(width: 8, height: 8)
                                    .foregroundColor(vmTest.proximityTestPassed ? .green : .red)
                                Spacer()
                                Text("Charger")
                                    .foregroundColor(.white)
                                Circle()
                                    .frame(width: 8, height: 8)
                                    .foregroundColor(vmTest.chargerTestPassed ? .green : .red)
                            }
                        }
                        .padding(.top, 40)
                        .padding(.horizontal,UIDevice.current.userInterfaceIdiom == .pad ? 180 : 40)
                    }
                Spacer()
                CustomActionButton(action: {
                    vmTest.coordinator.navigateTo(to: .firstView)
                    vmTest.successTestCount = 0
                    vmTest.successTestCount = 0.0
                    vmTest.buttonsTestPassed = false
                    vmTest.vibrationTestPassed = false
                    vmTest.chargerTestPassed = false
                    vmTest.proximityTestPassed = false
                    vmTest.vibrationCount = 0
                    vmTest.testPassed = false
                    
                }, label: "Start")
                .padding(.bottom, UIScreen.main.bounds.height > 680 ? 50 : 60)
                Spacer()
            }
        }
        .onAppear {
           
            vm.isTabBarVisible = true
         
        }
        .onDisappear{
            vmTest.successTestCount = 0
        }
        .onReceive(timer) { _ in
            if progress < vmTest.calculateSuccessPercentage() {
                progress += 1.0
            } else {
                timer.upstream.connect().cancel()
            }
        }
    }
}

