//
//  ResultSpeedLoader.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 14.08.2023.
//

import SwiftUI

struct ResultSpeedLoaderView: View {
    @ObservedObject var speedChecker: SpeedChecker
    
    @ObservedObject var speedVM: SpeedTestVM
    let maxSpeed: Double = 500.0 // Maximum speed in Mbps
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(maxWidth: .infinity , maxHeight: 7.5)
                .background(Color(red: 0.11, green: 0.11, blue: 0.11))
                .cornerRadius(25)
            
            Image("Rocket")
               
                .position(x: calculateRocketXPosition(), y: 100)
                .animation(.easeInOut, value: speedVM.progress)
                .padding(.horizontal)
                
            GeometryReader { geometry in
                Rectangle()
                    .frame(width: calculateProgressBarWidth(geometry: geometry), height: 7.5)
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
        .frame(height: 300)
        .padding(.horizontal)

    }
    
    func calculateRocketXPosition() -> CGFloat {
        let speedRatio = min(Double(speedChecker.download) / maxSpeed, 1.0) // Ensure max is 1
        let progressBarWidth = UIScreen.main.bounds.width - 200 // Assuming 20 padding on each side
        
        return CGFloat(speedRatio) * progressBarWidth
    }

    
    func calculateProgressBarWidth(geometry: GeometryProxy) -> CGFloat {
           let speedRatio = min(Double(speedChecker.download) / maxSpeed, 1.0) // Ensure max is 1
        print(speedChecker.download, "====================================")
           return geometry.size.width * CGFloat(speedRatio)
       }
}
