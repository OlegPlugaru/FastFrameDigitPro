//
//  ContentView.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 14.08.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm = ContentModel()
    @StateObject private var photosViewModel = PhotosViewModel(selectedImages: [], compressedImages: [])
    @State private var tabSelected: Tab = .speedTest
    @State var isShowTab = true
@StateObject var LocationVm = LocationVM()
    init() {
        UIView.appearance().isMultipleTouchEnabled = false
        UIView.appearance().isExclusiveTouch = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            getView(for: tabSelected)
                .frame(maxHeight: .infinity)
            TabBar(selectedTab: $tabSelected, vmAlert: vm)
                .disabled(!isShowTab)
                .opacity(vm.isTabBarVisible ? 1 : 0)
        }
    }
}

extension ContentView {
    @ViewBuilder
    func getView(for tab: Tab) -> some View {
        switch tab {
        case .compress:
            CompressView(viewModel: photosViewModel, vm: vm)
        case .adBlocker:
            AdBlockerView(vm: vm)
        case .speedTest:
            SpeedTestRootView(coordinator: SpeedTestCoordinator(vm: vm))
        case.testDevice:
            HardwareCheckRootView(coordinator: HardwareCheckCoordinator(contentViewModel: vm), isShowTab: $isShowTab)
        case .wifi:
            WifiView(vmAlert: vm, viewModel: LocationVm)
        }
    }
}

class ContentModel: ObservableObject {
    @Published var tabDisabled = false
    @Published var isTabBarVisible: Bool = true
    @Published var isShowSettings: Bool = false
    @Published var showSavePopup = false
    @Published var showPopup = false
    @Published var showhistorypopup = false
    @Published var privacyUrl = "https://google.com"
    @Published var termsUrl = "https://google.com"
}

