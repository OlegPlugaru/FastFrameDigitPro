//
//  TabBar.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 14.08.2023.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case compress
    case adBlocker
    case speedTest
    case testDevice
    case wifi
}

struct TabBar: View {
    @Binding var selectedTab: Tab
    @ObservedObject var vmAlert: ContentModel
    // @Binding var isShowTab: Bool
    @State var isMainState = true
    
    private let tabImages: [Tab: String] = [
        .compress: "compress",
        .adBlocker: "adBlocker",
        .speedTest: "speedTest",
        .testDevice: "testDevice",
        .wifi: "wifi"
    ]
    
    private let tabImagesActive: [Tab: String] = [
        .compress: "compressOn",
        .adBlocker: "adBlockerOn",
        .speedTest: "speedTestOn",
        .testDevice: "testDeviceOn",
        .wifi: "wifiOn"
    ]
    
    var body: some View {
        VStack(spacing:0) {
            HStack {
                Image("mainIcon")
                
                    .onTapGesture {
                        isMainState.toggle()
                        
                    }.offset(x: isMainState ? 0 : -1)
                    .padding(.leading, isMainState ? 0 : 16)
                    .animation(.easeInOut, value: isMainState)
                
                if isMainState == false {
                    
                    ForEach(Tab.allCases, id: \.rawValue) { tab in
                        let imageName = tab == selectedTab ? tabImagesActive[tab] : tabImages[tab]
                        Image(imageName ?? "")
                            .onTapGesture {
                                selectedTab = tab
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 10)
                            .padding(.trailing)
                    }
                }
            }
            .offset(x: isMainState ? 0 : 1)
           
            .animation(.easeInOut, value: !isMainState)
            .transition(.offset())
           
            .padding(.bottom, UIDevice.current.userInterfaceIdiom == .phone ?  UIScreen.main.bounds.height > 680 ? 8 : 22 : 30)
            .padding(.top)
        }
        .onChange(of: selectedTab) { newSelectedTab in
                   // Update isMainState when selectedTab changes
                   isMainState = true
               }
    }
}
