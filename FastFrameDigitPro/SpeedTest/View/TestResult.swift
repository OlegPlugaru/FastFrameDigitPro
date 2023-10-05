//
//  TestResult.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 14.08.2023.
//

import SwiftUI
import Combine
import CoreLocation
//import FGRoute

struct TestResult: View {
    @ObservedObject var vm: ContentModel
    @ObservedObject var speedVM: SpeedTestVM
    @ObservedObject var speedChecker: SpeedChecker
    @State var title = "Speed Test"
    @State var isFinished = false
    @State var results:[ConnectionData] = []
    @State var showPremium = false
    @State var isDisable = false
    @State var starting = false
    @State var testsPerformed: Int = UserDefaults.standard.integer(forKey: "TestsPerformed")
    @State var isAnimating = false
    
    var body: some View {
        ZStack {
            customBackgroundGradient()
                .ignoresSafeArea()
            if !speedChecker.testIsFinished && !isFinished {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 275, height:  UIScreen.main.bounds.height > 680 ? 180 : 150)
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1).opacity(0.2), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85).opacity(0.2), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                    .ignoresSafeArea()
                    .cornerRadius(275)
                    .blur(radius: 70)
                    .padding(.bottom, 350)
            }
            VStack {
                HeaderView(vm: vm, title: $title)
                if !speedChecker.testIsFinished && !isFinished {
                    LoaderView( speedVM: speedVM)
                        .onAppear {
                            speedVM.resetProgress()
                        }
                        .overlay {
                            VStack(spacing: 0) {
                                Text( String(format: "%.0f ", speedChecker.upload > 0 ? speedChecker.upload : speedChecker.download))
                                    .foregroundStyle(LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                                            Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 0.88),
                                        ],
                                        startPoint: UnitPoint(x: 0.5, y: 0),
                                        endPoint: UnitPoint(x: 0.5, y: 1)
                                    ))
                                    .font(.system(size:  UIScreen.main.bounds.height > 680 ? 32 : 30, weight: .bold, design: .rounded))
                                    .padding(0)
                                HStack {
                                    Image( speedChecker.upload > 0 ?  "Upload" : "Download")
                                    Text("Mbps")
                                        .foregroundStyle(LinearGradient(
                                            stops: [
                                                Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                                                Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 0.88),
                                            ],
                                            startPoint: UnitPoint(x: 0.5, y: 0),
                                            endPoint: UnitPoint(x: 0.5, y: 1)
                                        ))
                                        .font(.system(size: 20))
                                }
                            }
                            .offset(y: 50)
                        }
                        .padding(.bottom, 0)
                } else {
                    Text("Test Complete!")
                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                        .padding(.top, 30)
                        .padding(.bottom, 25)
                        .font(Font.system(size: 20))
                        .onAppear {
                            isFinished = true
                        }
                }
                Rectangle()
                    .frame(maxWidth: .infinity, minHeight: 230, maxHeight:  UIScreen.main.bounds.height > 680 ? UIDevice.current.userInterfaceIdiom == .pad ? 400 : 300 : 250)
                    .background(.clear)
                    .foregroundColor(.white.opacity(0.2))
                    .blur(radius: 220)
                    .overlay {
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(lineWidth: 2)
                            .foregroundStyle(LinearGradient(colors: [.gray,.clear, .clear], startPoint: .top, endPoint: .bottom))
                    }
                    .cornerRadius(40)
                    .padding(.horizontal)
                    .overlay(alignment: .top) {
                        
                        VStack(spacing:  UIScreen.main.bounds.height > 680 ? UIDevice.current.userInterfaceIdiom == .pad ? 50 : 30 : 15) {
                            HStack {
                                Image("Download")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                Text("Download")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(String(format: "%.0f Mb/s", speedChecker.download))
                                    .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                            }
                            HStack {
                                Image("Upload")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                Text("Upload")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(String(format: "%.0f Mb/s", speedChecker.upload))
                                    .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                            }
                            HStack {
                                Image("Ping")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                Text("Ping")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(String(format: "%.0f Ms", speedChecker.ping))
                                    .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                            }
                            HStack {
                                Image("IP")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                Text("IP Adress")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(speedChecker.results?.ipAddress ?? "")
                                    .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                            }
                            HStack {
                                Image("provider")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                Text("Provider")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(speedChecker.results?.ispName ?? "")
                                    .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                            }
                        }
                        .padding(.top, 40)
                        .padding(.horizontal, 40)
                    }
                    .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 70 : 0)
                Spacer()
                if !isFinished {
                    CustomActionButton(action: {
//                        if IAPManager.shared().isPurchased {
                            results = []
                            starting = true
                            speedChecker.resetValues()
                            if !isAnimating {
                                isAnimating = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    speedVM.animateLoader(animationDuration: 9.0)
                                    isAnimating = false
                                }
                            }
                            DispatchQueue.main.async {
                                speedChecker.runSpeedTestTouched()
                                speedChecker.action = {
                                    startTests(finished:{
                                        starting = false
                                    })
                                }
                            }
 //                       }
//                                       else {
//                            incrementTestCount()
//                            if testsPerformed <= 3 {
//                                results = []
//                                starting = true
//                                speedChecker.resetValues()
//                                if !isAnimating {
//                                    isAnimating = true
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                                        speedVM.animateLoader(animationDuration: 9.0)
//                                        isAnimating = false
//                                    }
//                                }
//                                DispatchQueue.main.async {
//                                    speedChecker.runSpeedTestTouched()
//                                    speedChecker.action = {
//                                        startTests(finished:{
//                                            starting = false
//                                        })
//                                    }
//                                }
//                            } else {
//                                showPremium = true
//                            }
//                        }
                    }, label: "Start Test", isDisabled: starting)
                    .padding(.bottom, UIScreen.main.bounds.height > 680 ? 50 : 30)
                }
                Spacer()
                if speedChecker.testIsFinished || isFinished {
                    HStack {
                        CustomActionButton(action: {
                            speedVM.coordinator.navigateTo(to: .history)
                        }, label: "History")
                        Spacer()
                        CustomActionButton(action: {
                            isFinished = false
//                            if IAPManager.shared().isPurchased {
                                results = []
                                starting = true
                                speedChecker.resetValues()
                                if !isAnimating {
                                    isAnimating = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        speedVM.animateLoader(animationDuration: 9.0)
                                        isAnimating = false
                                    }
                                }
                                DispatchQueue.main.async {
                                    speedChecker.runSpeedTestTouched()
                                    speedChecker.action = {
                                        startTests(finished:{
                                            starting = false
                                        })
                                    }
                                }
//                            }else {
//                                isFinished = false
//                                incrementTestCount()
//                                if testsPerformed <= 3 {
//                                    results = []
//                                    starting = true
//                                    speedChecker.resetValues()
//                                    if !isAnimating {
//                                        isAnimating = true
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                                            speedVM.animateLoader(animationDuration: 9.0)
//                                            isAnimating = false
//                                        }
//                                    }
//                                    DispatchQueue.main.async {
//                                        speedChecker.runSpeedTestTouched()
//                                        speedChecker.action = {
//                                            startTests(finished:{
//                                                starting = false
//                                            })
//                                        }
//                                    }
//                                } else {
//                                    showPremium = true
//                                }
//                            }
                            
                        }, label: "Restart")
                    }
                    .padding(.bottom, UIScreen.main.bounds.height > 680 ? 50 : 50)
                    .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 90 : 16)
                }
                Spacer()
            }
        }
        .onDisappear{
            if(!speedChecker.testIsFinished ){
                speedChecker.forceFinish()
                speedVM.resetProgress()
                results = []
                speedVM.navigateTo(to: .animation)
                speedChecker.resetValues()
            }
            speedVM.resetProgress()
        }
//        .fullScreenCover(isPresented: $showPremium, content: {
//            PremiumView()
//        })
        .onChange(of: speedChecker.upload > 0, perform: { newValue in
            if !speedChecker.testIsFinished && !isFinished {
                speedVM.resetProgress()
                if !isAnimating {
                    isAnimating = true
                    speedVM.animateLoader(animationDuration: 12.0)
                    isAnimating = false
                }
            }
        })
    }
    
    func startTests(finished: @escaping()->Void) {
        DispatchQueue.main.async {
            pingServer(url: speedChecker.serverURL ?? "" , completion: {ping,loss, finish in
                speedChecker.ping = round(ping * 1000)
                speedChecker.loss = loss
                if(finish){
                    finished()
                }
            })
        }
    }
    
//    func incrementTestCount() {
//        if !IAPManager.shared().isPurchased {
//            testsPerformed += 1
//            UserDefaults.standard.set(testsPerformed, forKey: "TestsPerformed")
//        }
//    }
    
//    private func getNetworkData(){
//        results.append( ConnectionData(param: "ISP", value: fineResult(value: speedChecker.results?.ispName)))
//        results.append( ConnectionData(param: "Internal IP", value: FGRoute.getIPAddress() ?? "--"))
//        results.append( ConnectionData(param: "External IP", value: fineResult(value: speedChecker.results?.ipAddress)))
//        results.append( ConnectionData(param: "Connection Type", value: fineResult(value: speedChecker.results?.connectionType)))
//        results.append( ConnectionData(param: "Location", value: fineResult(value: speedChecker.results?.userCityName)))
//        results.append( ConnectionData(param: "Device", value: fineResult(value: speedChecker.results?.deviceInfo)))
//    }
    
    private func fineResult(value: String?)->String{
        if let string = value {
            return string
        }
        return "--"
    }
}


