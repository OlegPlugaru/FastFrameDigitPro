//
//  WifiView.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 14.08.2023.
//

import SwiftUI
//import FGRoute
import Network
import Foundation

struct WifiView: View {
    @State var title = "Network"
    @ObservedObject var vmAlert: ContentModel
    @ObservedObject var viewModel : LocationVM
    
    var body: some View {
        ZStack {
            customBackgroundGradient()
                .ignoresSafeArea()
            VStack {
                HStack {
                    HeaderView(vm: vmAlert, title: $title)
                }
                Spacer()
                ScrollView {
                    VStack(spacing: 30) {
                        Text("Connection")
                            .foregroundStyle(LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 0.88),
                                ],
                                startPoint: UnitPoint(x: 0.5, y: 0),
                                endPoint: UnitPoint(x: 0.5, y: 1)
                            ))
                        HStack {
                            Text("Current Connection")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(viewModel.connectionType)
                                .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                        }
                        HStack {
                            Text("Wi-Fi Connected")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(viewModel.connectionType == "Wi-Fi" ? "Yes" : "No")
                                .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                            Circle()
                                .frame(width: 6, height: 6)
                                .foregroundColor(viewModel.connectionType == "Wi-Fi" ? .green : .red)
                        }
                        HStack {
                            Text("Internal IP")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(viewModel.deviceIp )
                                .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                        }
                        HStack {
                            Text("External IP")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(viewModel.usersIP)
                                .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                        }
                    }
                    .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 160 : 40)
                    .padding(.vertical)
                    .padding(.bottom, 40)
                    .background {
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: 390)
                            .background(.clear)
                            .foregroundColor(.white.opacity(0.2))
                            .blur(radius: 220)
                            .overlay {
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(lineWidth: 2)
                                    .foregroundStyle(LinearGradient(colors: [.gray,.clear, .clear], startPoint: .top, endPoint: .bottom))
                            }
                            .cornerRadius(40)
                            .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 120 : 16)
                    }
                    .padding(.top, 40)
                    Spacer()
                    VStack(spacing: 30) {
                        Text("IP Geolocation")
                            .foregroundStyle(LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 0.88),
                                ],
                                startPoint: UnitPoint(x: 0.5, y: 0),
                                endPoint: UnitPoint(x: 0.5, y: 1)
                            ))
                        HStack {
                            Text("Provider")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(viewModel.fetchedLocation?.isp ?? "")
                                .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                        }
                        HStack {
                            Text("City")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(viewModel.fetchedLocation?.city ?? "")
                                .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                        }
                        HStack {
                            Text("Region")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(viewModel.fetchedLocation?.state_prov ?? "")
                                .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                        }
                        HStack {
                            Text("Country")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(viewModel.fetchedLocation?.country_name ?? "")
                                .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                        }
                        HStack {
                            Text("Timezone")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(viewModel.timeZoneOffsetString )
                                .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                        }
                    }
                    .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 160 : 40)
                    .padding(.vertical)
                    .padding(.bottom, 40)
                    .background {
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: 390)
                            .background(.clear)
                            .foregroundColor(.white.opacity(0.2))
                            .blur(radius: 220)
                            .overlay {
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(lineWidth: 2)
                                    .foregroundStyle(LinearGradient(colors: [.gray,.clear, .clear], startPoint: .top, endPoint: .bottom))
                            }
                            .cornerRadius(40)
                            .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 120 : 16)
                    }
                    .padding(.top, 40)
                }
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            let apiKey = "bdf19785722e4355a6ba087c3964a606"
           
            viewModel.fetchIPInformationUsingAPI(apiKey: apiKey)
            
        }
    }
}


