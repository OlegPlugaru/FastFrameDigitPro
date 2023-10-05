//
//  AdBlockerViewModel.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 05.10.2023.
//

import Foundation
import SwiftUI
import SafariServices

final class BlockerViewModel: ObservableObject {
    @Published var isAdblockerOn: Bool = false
    @Published var isPopupBlockerOn: Bool = false
    @Published var isTrackerBlockerOn: Bool = false
    @Published var isAdultContentBlockerOn: Bool = false
    @Published var faceDownOn: Bool = false
    @Published var goToPremium: Bool = false
    @Published var hideTabBar = true
    @Published var isShowingAlert: Bool = false
    
    func reloadBlocker(for identifier: String, completion: @escaping (Error?) -> Void) {
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: identifier) { error in
            if let error = error {
                print("ERROR activating rules for \(identifier) - \(error)")
                completion(error)
            } else {
                print("\(identifier) block on")
                completion(nil)
            }
        }
    }
    
    func reloadBlockerState(for identifier: String) {
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: identifier) { state, error in
            DispatchQueue.main.async {
                if let state = state {
                    withAnimation(.spring()) {
                        switch identifier {
                        case "FastFrameDigitPro.Advertisments":
                            self.isAdblockerOn = state.isEnabled
                        case "FastFrameDigitPro.Popups":
                            self.isPopupBlockerOn = state.isEnabled
                        case "FastFrameDigitPro.Trackers":
                            self.isTrackerBlockerOn = state.isEnabled
                        case "FastFrameDigitPro.AdultContent":
                            self.isAdultContentBlockerOn = state.isEnabled
                        default:
                            break
                        }
                    }
                    
                    if state.isEnabled {
                        self.reloadBlocker(for: identifier) { _ in }
                    }
                } else {
                    withAnimation(.spring()) {
                        switch identifier {
                        case "FastFrameDigitPro.Advertisments":
                            self.isAdblockerOn = false
                        case "FastFrameDigitPro.Popups":
                            self.isPopupBlockerOn = false
                        case "FastFrameDigitPro.Trackers":
                            self.isTrackerBlockerOn = false
                        case "FastFrameDigitPro.AdultContent":
                            self.isAdultContentBlockerOn = false
                        default:
                            break
                        }
                    }
                    print(error ?? "")
                }
            }
        }
    }
    
    func reloadAllBlockers() {
        reloadBlocker(for: "FastFrameDigitPro.Advertisments") { _ in }
        reloadBlocker(for: "FastFrameDigitPro.Popups") { _ in }
        reloadBlocker(for: "FastFrameDigitPro.Trackers") { _ in }
        reloadBlocker(for: "FastFrameDigitPro.AdultContent") { _ in }
    }
}
