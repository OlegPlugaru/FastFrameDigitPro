//
//  CheckHardwareView.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 14.08.2023.
//

import SwiftUI

struct CheckHardwareView: View {
    @ObservedObject var vm: ContentModel
    @ObservedObject var vmTest: CheckHardwareVM
    @State var title = "Hardware Test"
    @State var showPremium = false
    @Binding var isShowTab: Bool
    
    var body: some View {
        ZStack {
            customBackgroundGradient()
                .ignoresSafeArea()
            VStack {
                HStack {
                    HeaderView(vm: vm, title: $title)
                }
                Spacer()
                Text("There’s no information about your device hardware yet.")
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .frame(width: 259, alignment: .center)
                    .padding(.bottom)
                Image("deviceQuestion")
                    .padding(.bottom)
                CustomActionButton(action: {
                 
//                    if IAPManager.shared().isPurchased {
                        vmTest.restartCountdownTimer()
                        vmTest.navigateTo(to: .buttonUp)
                        vm.isTabBarVisible = false
                       print(vm)
//                    } else {
//                        showPremium = true
//                    }
                }, label: "Start")
                .padding(.top)
                Spacer()
            }
        }
        .hiddenTabBar()
//        .fullScreenCover(isPresented: $showPremium) {
//            PremiumView()
//        }
    }
}



