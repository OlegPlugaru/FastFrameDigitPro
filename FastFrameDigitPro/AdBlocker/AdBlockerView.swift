//
//  AdBlockerView.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 05.10.2023.
//

import SwiftUI

struct AdBlockerView: View {
    @ObservedObject var vm: ContentModel
    @State var title = "Ad Shield"
    @StateObject var viewModel  = BlockerViewModel()
    @State var showPremium = false
    
    var body: some View {
        ZStack {
            customBackgroundGradient()
                .ignoresSafeArea()
            VStack {
                HeaderView(vm: vm, title: $title)
                Spacer()
                Text("Enjoy carefree browsing with our Ad Shield feature")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .frame(width: 321, alignment: .center)
                    .padding(.bottom, 30)
                Group {
                    AdblockCell(viewModel: viewModel, title: "Advertisments", blockerIdentifier: "FastFrameDigitPro.Advertisments", isBlockerOn: $viewModel.isAdblockerOn, showPremium: $showPremium)
                    AdblockCell(viewModel: viewModel, title: "Pop-Ups", blockerIdentifier: "FastFrameDigitPro.Popups", isBlockerOn: $viewModel.isPopupBlockerOn, showPremium: $showPremium)
                    AdblockCell(viewModel: viewModel, title: "Adult Content", blockerIdentifier: "FastFrameDigitPro.AdultContent", isBlockerOn: $viewModel.isAdultContentBlockerOn, showPremium: $showPremium)
                    AdblockCell(viewModel: viewModel, title: "Trackers", blockerIdentifier: "FastFrameDigitPro.Trackers", isBlockerOn: $viewModel.isTrackerBlockerOn, showPremium: $showPremium)
                }
                .padding(.bottom, 10)
                Spacer()
            }
        }
//        .fullScreenCover(isPresented: $showPremium) {
//            PremiumView()
//        }
    }
}

struct AdblockCell: View {
    @ObservedObject var viewModel: BlockerViewModel
    var title: String
    var blockerIdentifier: String
    @Binding var isBlockerOn: Bool
    @Binding var showPremium: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(title)
                .foregroundColor(Color(red: 0.97, green: 0.98, blue: 0.99))
                .padding(.leading, 30)
            Spacer()
            setToggles()
                .padding(.horizontal, 30)
        }
        .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 700 : 360, height: UIDevice.current.userInterfaceIdiom == .pad ? 100 : 70, alignment: .center)
        .background(Color(red: 0.21, green: 0.23, blue: 0.24).opacity(0.5))
        .cornerRadius(40)
        .overlay {
            RoundedRectangle(cornerRadius: 40)
                .stroke(lineWidth: 1)
                .foregroundStyle(LinearGradient(colors: [.gray,.clear, .clear], startPoint: .top, endPoint: .bottom))
        }
        .onAppear {
            viewModel.reloadBlockerState(for: blockerIdentifier)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            viewModel.reloadBlockerState(for: blockerIdentifier)
        }
        .alert(isPresented: $viewModel.isShowingAlert) {
            Alert(
                title: Text("Enable AD Shield"),
                message: Text("To enable AD Shield, follow these steps:\n\n1. Open the 'Settings' app on your device.\n2. Scroll down and tap on 'Safari'.\n3. Tap on 'Extensions'.\n4. Find 'Fast Frame DigitPro' in the list and turn on the toggle switch."),
                primaryButton: .default(Text("Continue"), action: {
                    openSettings()
                }),
                secondaryButton: .cancel(Text("Cancel"), action: {
                    viewModel.reloadBlockerState(for: blockerIdentifier)
                })
            )
        }
    }
    func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
}

extension AdblockCell {
    func setToggles() -> some View{
        HStack{
            RoundedRectangle(cornerRadius: 100)
                .frame(width: 52, height: 32)
                .foregroundStyle(LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.08, green: 0.08, blue: 0.08), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.18, green: 0.2, blue: 0.21), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.82, y: 0.88),
                    endPoint: UnitPoint(x: 0.2, y: 0.11)
                ))
                .shadow(color: .gray, radius: 18, x: -11, y: -5)
                .shadow(color: .black, radius: 16, x: 3, y: 8)
                .overlay{
                    Circle()
                        .foregroundStyle(isBlockerOn ? LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        ) : LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.22, green: 0.22, blue: 0.22), location:18),
                                Gradient.Stop(color: Color(red: 0.31, green: 0.31, blue: 0.31), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        ))
                        .frame(width: 26, height: 26)
                        .offset(x: isBlockerOn ? 10 : -10, y: 0)
                }
                .onTapGesture {
                    withAnimation(.spring(), {
//                        if IAPManager.shared().isPurchased {
                            viewModel.reloadBlockerState(for: blockerIdentifier)
                            viewModel.isShowingAlert = true
//                        } else {
//                            showPremium = true
//                        }
                    })
                }
        }
    }
}


