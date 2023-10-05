//
//  ClearHistoryPopup.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import SwiftUI

struct ClearHistoryPopup: View {
//    @ObservedObject var vm: ContentModel
    @Binding var showAlert: Bool
    @Binding var history: [(pd:PackageData,lcd:[LightConnData])]
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        
        ZStack {
          //  if vm.showClearHistoryPopup {
                Color.black
                    .opacity(0.2)
                    .ignoresSafeArea()
                    
                VStack {
                    Text("Do you want to clean all speed test history?")
                        .padding(.bottom)
                        .foregroundColor(.white)
                    HStack(spacing: 50) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Text("No")
                        }
                        .accentColor(.white)
                        Button {
                                GlobalSettings.clearHistory()
                                history = []
                            presentationMode.wrappedValue.dismiss()

                        } label: {
                            Text("Yes")

                                .foregroundStyle(LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                                        Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 0.88),
                                    ],
                                    startPoint: UnitPoint(x: 0.5, y: 0),
                                    endPoint: UnitPoint(x: 0.5, y: 1)
                                ))

                        }

                    }
                   
                    .background( Color(red: 0.16, green: 0.18, blue: 0.2).blur(radius: 100))
                }
                
                .padding(40)
                .background(.ultraThinMaterial)
                .cornerRadius(40)

                
            }
        }
  //  }
}

