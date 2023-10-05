//
//  SpeedTestView.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 14.08.2023.
//

import SwiftUI
import Foundation
//import FGRoute
import CoreLocation

struct SpeedTestView: View {
    @ObservedObject var vm: ContentModel
    @ObservedObject var speedMV: SpeedTestVM
    @ObservedObject var speedChecker :  SpeedChecker
    @State var title = "Speed Test"
    @State var showPremium = false
    
    var body: some View {
        ZStack {
            customBackgroundGradient()
                .ignoresSafeArea()
            VStack {
                HeaderView(vm: vm , title: $title)
                Spacer()
                VStack {
                    Spacer()
                    FlyingRocket(isFlying: $speedMV.isFlying)
                    CustomActionButton(action: {
                                speedMV.startTest(locationManager: self.speedChecker.locationManager)
                    }, label: "Start Test", isDisabled: speedMV.isFlying)
                    .padding(.top)
                    Spacer()
                }
            }
        }
        .onAppear{
            speedChecker.resetValues()
        }
        .onDisappear {
            speedMV.cancel()
        }
//        .fullScreenCover(isPresented: $showPremium) {
//            PremiumView()
//        }
    }
}



