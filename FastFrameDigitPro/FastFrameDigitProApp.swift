//
//  FastFrameDigitProApp.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 05.10.2023.
//

import SwiftUI

@main
struct FastFrameDigitProApp: App {
    
    @State var isAgree: Bool = false
    var body: some Scene {
        WindowGroup {
            ZStack{
                if isAgree {
                    ContentView()
                } else {
                    LaunchScreenView(isAgree: $isAgree)
                }
            }.task{
                isAgree = CurrentSession.isAgree
            }
        }
    }
}


class CurrentSession {
    static var isAgree: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "agree_privacy_terms")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "agree_privacy_terms")
        }
    }
}
