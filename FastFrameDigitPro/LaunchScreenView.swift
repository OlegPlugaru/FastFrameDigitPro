//
//  SwiftUIView.swift
//  ProtectPlusGuardme
//
//  Created by Cocadei Ludmila on 02.10.2023.
//

import SwiftUI

struct LaunchScreenView: View {
    @Environment(\.openURL) var openURL
    @StateObject var viewModel = ContentModel()
    @Binding var isAgree: Bool
    @State var isChecked: Bool = false
    let adaptive = AdaptiveUI.shared
    var body: some View {
        ZStack {
            LinearGradient(
            stops: [
            Gradient.Stop(color: Color(red: 0.16, green: 0.18, blue: 0.2), location: 0.00),
            Gradient.Stop(color: Color(red: 0.09, green: 0.09, blue: 0.1), location: 0.99),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
            )
            .ignoresSafeArea()
            
            if UIScreen.main.bounds.height > 680 {
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1).opacity(0.2), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85).opacity(0.2), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
                .frame(width: 276, height: 206)
                .cornerRadius(276)
                .blur(radius: 100)
            } else {
                Image("neon")
            }
            VStack {
                Spacer()
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: adaptive.setFrameSize(valueByDesign: 215),height: adaptive.setFrameSize(valueByDesign: 74))
                   // .scaleEffect(adaptive.setImageSize())
                
                Spacer()
                
                
                VStack(spacing: adaptive.setPadding(paddingByDesign: 20)) {
                    
                    Button(action: {
                        if isChecked {
                            CurrentSession.isAgree = true
                            isAgree = true
                        }
                    }) {
                        Text("Continue")
                            .font(.custom("MavenPro-Regular", size: adaptive.setFontSize(fontSizeByDesign: 18)))
                            
                            .foregroundStyle(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                                        Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 0.88),
                                    ],
                                    startPoint: UnitPoint(x: 0.5, y: 0),
                                    endPoint: UnitPoint(x: 0.5, y: 1)
                                )
                            )
                            .padding(.bottom, 5)
//                           .padding(.horizontal, adaptive.setPadding(paddingByDesign: 60))
//                            .padding(.vertical, adaptive.setPadding(paddingByDesign: 20))
                    }
                    .background {
                        Image("Tab bar")
                            .resizable()
                            .scaledToFill()
                            .frame(width: adaptive.setFrameSize(valueByDesign: 390), height: adaptive.setFrameSize(valueByDesign: 81))
                            .padding(.horizontal)
                    }
                    
                  //  .cornerRadius(adaptive.setPadding(paddingByDesign: 30))
                }
                .padding(.bottom, adaptive.setPadding(paddingByDesign: 30))
                    
                    HStack(){
                        Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                            .resizable()
                            .frame(width: adaptive.setPadding(paddingByDesign: 20), height: adaptive.setPadding(paddingByDesign: 20))
                            .padding(.trailing, 10)
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    isChecked.toggle()
                                }
                                
                            }
                        
                        
                        
                        HStack {
                            Text("By continuing, I agree with ")
                                .font(.system( size: adaptive.setFontSize(fontSizeByDesign: 14)))
                            
                            Text("PP ")
                                .font(.system( size: adaptive.setFontSize(fontSizeByDesign: 14)))
                                .onTapGesture {
                                    guard let url = URL(string: viewModel.privacyUrl) else {return}
                                    openURL(url)
                                }
                            Text("and ")
                                .font(.system( size: adaptive.setFontSize(fontSizeByDesign: 14)))
                            
                            Text("EULA")
                                .font(.system( size: adaptive.setFontSize(fontSizeByDesign: 14)))
                                .onTapGesture {
                                    guard let url = URL(string: viewModel.termsUrl) else {return}
                                    openURL(url)
                                }
                        }
                    
                    }
                    .foregroundColor(.gray)
                    .padding(.bottom, adaptive.setPadding(paddingByDesign: 30))

      
                
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal)
         //   .background(.white)
         //   .cornerRadius(adaptive.setPadding(paddingByDesign: 22))
            
        }
    }
}

