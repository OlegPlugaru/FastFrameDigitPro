//
//  LoaderView.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 14.08.2023.
//

import SwiftUI

struct LoaderView: View {
    @ObservedObject var speedVM: SpeedTestVM
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(maxWidth: .infinity , maxHeight: 7.5)
                .background(Color(red: 0.11, green: 0.11, blue: 0.11))
                .cornerRadius(25)
            Image("Rocket")
                .position(x: speedVM.calculateRocketXPosition(), y: 30)
                .animation(.easeInOut, value: speedVM.progress)
                .padding(.horizontal)
            GeometryReader { geometry in
                Rectangle()
                    .frame(width: geometry.size.width * speedVM.progress, height: 7.5)
                    .foregroundColor(Color.clear)
                    .background(LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                    )
                    )
                    .shadow(color: Color(red: 0, green: 0.16, blue: 0.82), radius: 4, x: 0.6, y: 0.6)
                    .animation(.easeInOut, value: speedVM.progress)
                    .cornerRadius(25)
            }
            .frame(height: 7.5)
            .cornerRadius(25)
        }
        .frame(height: UIScreen.main.bounds.height > 680 ? 200 : 160, alignment: .top)
        .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 90 : 16)
        
    }
}
