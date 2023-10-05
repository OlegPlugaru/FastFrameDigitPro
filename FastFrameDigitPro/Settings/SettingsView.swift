//
//  SettingsView.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 14.08.2023.
//


import SwiftUI


struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: ContentModel
    @State var showPremium = false
    @State private var showSafari = false
   
    @State private var safariURL: IdentifiableURL?
    
    var body: some View {
        ZStack {
            customBackgroundGradient()
                .ignoresSafeArea()
            VStack {
                HStack {
                    Text("Settings")
                        .font(.system(size: UIScreen.main.bounds.height > 680 ? 24 : 19))
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding( UIScreen.main.bounds.height > 680 ? 8 : 6)
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
                                    .shadow(color: .black.opacity(0.35), radius: 18, x: 7, y: 10)
                            }
                            .overlay {
                                Circle()
                                    .inset(by: 1)
                                    .stroke(lineWidth: 1)
                                
                                
                                    .foregroundStyle(LinearGradient(colors: [Color(red: 0.16, green: 0.18, blue: 0.2),.clear ], startPoint: .bottomTrailing, endPoint: .top))
                                
                            }
                        
                    }
                }
                .padding(.top, UIDevice.current.userInterfaceIdiom == .pad ? 10 : 0)
                .padding(.horizontal)
                .padding(.bottom, UIDevice.current.userInterfaceIdiom == .pad ? 100 : 50)
         //       if !IAPManager.shared().isPurchased {
//                    Button {
//                        showPremium = true
//                    } label: {
//                        HStack {
//                            Image("GO")
//                            Image("Crown")
//                            Spacer()
//                            Image("right")
//                        }
//                        .padding()
//                        .padding(.vertical, 5)
//                        
//                        .background(Rectangle()
//                            .foregroundColor(.clear)
//                            .frame(height:   UIDevice.current.userInterfaceIdiom == .pad ? 100 : 70)
//                            .background(Color(red: 0.14, green: 0.15, blue: 0.17))
//                            .cornerRadius(24)
//                            .shadow(color: .black.opacity(0.25), radius: 6, x: 6, y: 6)
//                            .shadow(color: .white.opacity(0.25), radius: 6, x: -6, y: -6))
//                        .padding()
//                        .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 150 : 0)
//                    }
//                } else {
//                    Image("sad")
//                        .opacity(0)
//                        .frame(height:   UIDevice.current.userInterfaceIdiom == .pad ? 100 : 70)
//                }
                
                Button {
                    self.showSafari = true
                    self.safariURL = IdentifiableURL(url: URL(string: vm.termsUrl)!)
                } label: {
                    HStack {
                        Text("Terms of Use")
                            .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                            .font(.system(size: 16))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                    }
                    .padding()
                    .padding(.vertical, 5)
                    .frame(height:   UIDevice.current.userInterfaceIdiom == .pad ? 100 : 70)
                    .background(Rectangle()
                        .foregroundColor(.clear)
                       
                        .background(Color(red: 0.14, green: 0.15, blue: 0.17))
                        .cornerRadius(24)
                        .shadow(color: .black.opacity(0.25), radius: 6, x: 6, y: 6)
                        .shadow(color: .white.opacity(0.25), radius: 6, x: -6, y: -6))
                    .padding()
                    .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 150 : 0)
                }
                
                Button {
                    self.showSafari = true
                    self.safariURL = IdentifiableURL(url: URL(string: vm.privacyUrl)!)
                } label: {
                    HStack {
                        Text("Privacy Policy")
                            .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                            .font(.system(size: 16))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                    }
                    .padding()
                    .padding(.vertical, 5)
                    .frame(height:   UIDevice.current.userInterfaceIdiom == .pad ? 100 : 70)
                    .background(Rectangle()
                        .foregroundColor(.clear)
                       
                        .background(Color(red: 0.14, green: 0.15, blue: 0.17))
                        .cornerRadius(24)
                        .shadow(color: .black.opacity(0.25), radius: 6, x: 6, y: 6)
                        .shadow(color: .white.opacity(0.25), radius: 6, x: -6, y: -6))
                    .padding()
                    .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 150 : 0)
                }
                Spacer()
            }
           
        }
        .sheet(item: $safariURL) { identifiableURL in
              SFSafariViewWrapper(url: identifiableURL.url)
                .edgesIgnoringSafeArea([.top, .bottom])
            }
//        .fullScreenCover(isPresented: $showPremium) {
//            PremiumView()
//        }
    }
}


