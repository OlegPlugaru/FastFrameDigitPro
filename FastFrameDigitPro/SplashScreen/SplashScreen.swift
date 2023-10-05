//
//  SplashScreen.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 11.08.2023.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
          customBackgroundGradient()
                .ignoresSafeArea()
            
            
            Image("logo")
                .frame(width: 276, height: 205)
                .background(
                LinearGradient(
                stops: [
                Gradient.Stop(color: Color(red: 0.2, green: 0.7, blue: 1).opacity(0.2), location: 0),
                Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.8).opacity(0.2), location: 1),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
                )
                .cornerRadius(276)
                .blur(radius: 60)
               
                )
               
               
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
