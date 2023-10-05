//
//  HeaderView.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 14.08.2023.
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var vm: ContentModel
    @State var showSettings = false
    @Binding var title: String
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.system(size: UIScreen.main.bounds.height > 680 ? 24 : 19))
                .padding(.top, 8)
                .foregroundColor(.white)
            Spacer()
            Button {
               showSettings = true
            } label: {
                Image("settings")
                    .padding(UIScreen.main.bounds.height > 680 ? 8 : 6)
                    .background {
                        Circle()
                            .fill(LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.08, green: 0.08, blue: 0.08), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.18, green: 0.2, blue: 0.21), location: 1.00),
                                ],
                                startPoint: UnitPoint(x: 0.82, y: 0.88),
                                endPoint: UnitPoint(x: 0.2, y: 0.11)
                            )
                            )
                            .overlay {
                                Circle()
                                    .inset(by: 1)
                                    .stroke(lineWidth: 1)
                                   
                                    
                                    .foregroundStyle(LinearGradient(colors: [Color(red: 0.16, green: 0.18, blue: 0.2),.clear ], startPoint: .bottomTrailing, endPoint: .top))
                                    
                            }
                            .shadow(color: .black.opacity(0.35), radius: 18, x: 7, y: 10)
                    }
            }
        }
        .padding(.top, UIDevice.current.userInterfaceIdiom == .pad ? 10 : 0)
        .padding(.horizontal)
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView(vm: vm)
        }
    }
    
}


