//
//  SwiftUIView.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 15.08.2023.
//

import SwiftUI

struct FlyingRocket: View {
    @Binding var isFlying: Bool
    
    var body: some View {
  // ZStack {
          
            VStack(alignment: .leading) {
                Image("Rocket") // Replace with the actual image name
                    .resizable()
                    .frame(width: 100, height: 100)
                    .background( Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 275, height: 205)
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
                        .cornerRadius(275)
                        .blur(radius: 60))
                    .rotationEffect(.degrees(-30))
                    .offset(x: isFlying ? UIDevice.current.userInterfaceIdiom == .pad ? 950 : 450 : -200, y: isFlying ? -200 : 0 )
                    .rotationEffect(.degrees(isFlying ? 0 : 30))
                    .animation(isFlying ? .easeInOut(duration: 3.0) : nil, value: isFlying)
                    
                
                
            }
            
            .frame(maxWidth: .infinity, alignment: .leading)
      //  }
        
    }
    
    struct FlyingOrigamiView_Previews: PreviewProvider {
        static var previews: some View {
            FlyingRocket(isFlying: .constant(false))
        }
    }
}

