//
//  TestFailedView.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import SwiftUI

struct TestFailedView: View {
    @ObservedObject var vm: ContentModel
    @ObservedObject var vmTest: CheckHardwareVM
    
    var body: some View {
        ZStack {
            customBackgroundGradient()
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button {
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
                                    ))
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
                Text("\(vmTest.coordinator.currentView.viewText) test failed!")
                    .font(
                        Font.system(size: 20)
                            .weight(.medium)
                    )
                    .kerning(0.03)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
                Image(vmTest.coordinator.currentView.imageName)
                    .resizable()
                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ?  140 : 95, height:  UIDevice.current.userInterfaceIdiom == .pad ?  140 : 95)
                    .background {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 274, height: 204)
                            .background(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.93, green: 0.54, blue: 0.54).opacity(0.15), location: 0.00),
                                        Gradient.Stop(color: Color(red: 0.48, green: 0.1, blue: 0.1).opacity(0.15), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 0.5, y: 0),
                                    endPoint: UnitPoint(x: 0.5, y: 1)
                                )
                            )
                            .cornerRadius(274)
                            .blur(radius: 100)
                    }
                Spacer()
                CustomActionButton(action: {
                    if vmTest.coordinator.currentView == .buttonFailed {
                        vmTest.navigateTo(to: .vibration)
                    } else if vmTest.coordinator.currentView == .vibrationFailed {
                        vmTest.navigateTo(to: .proximity)
                    } else if vmTest.coordinator.currentView == .proximityFailed {
                        vmTest.navigateTo(to: .charger)
                    } else if vmTest.coordinator.currentView == .chargerFailed {
                        vmTest.navigateTo(to: .hardwareResults)
                    }
                }, label: "Next")
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

