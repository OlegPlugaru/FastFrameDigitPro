//
//  CompressView.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 14.08.2023.
//

import SwiftUI
import PhotosUI

struct CompressView: View {
    @State var title = "Photo Compress"
    @ObservedObject var viewModel: PhotosViewModel
    @State private var isImagePickerPresented = false
    @State private var isActive: Bool = false
    @ObservedObject var vm: ContentModel
    @State var isSheetPresented = false
    @State var showPremium = false
    
    var body: some View {
        NavigationView {
            ZStack {
                customBackgroundGradient()
                    .ignoresSafeArea()
                NavigationLink("", isActive: $isActive) {
                    SelectedFilesView(viewModel: viewModel, vmAlert: vm)
                        .navigationBarBackButtonHidden(true)
                }
                VStack {
                    HeaderView(vm: vm , title: $title)
                    Spacer()
                    Image("selectImageGallery")
                        .padding(.bottom, UIDevice.current.userInterfaceIdiom == .pad ? 80 : 0)
                    Text("Select from gallery")
                        .foregroundColor(.white)
                    Button {
       //                 if IAPManager.shared().isPurchased {
                            viewModel.fetched_photos = viewModel.fetchPhotosFromGallery()
                            self.isImagePickerPresented = true
      //                  } else {
            //                showPremium = true
             //           }
                    } label: {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.08, green: 0.08, blue: 0.08), location: 0.00),
                                        Gradient.Stop(color: Color(red: 0.18, green: 0.2, blue: 0.21), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 0.82, y: 0.88),
                                    endPoint: UnitPoint(x: 0.2, y: 0.11)
                                ))
                                .frame(width: 75, height: 75)
                                .overlay {
                                    Circle()
                                        .inset(by: 1)
                                        .stroke(lineWidth: 1)
                                        .foregroundStyle(LinearGradient(colors: [Color(red: 0.16, green: 0.18, blue: 0.2),.clear ], startPoint: .bottomTrailing, endPoint: .top))
                                }
                            Image(systemName: "plus")
                                .font(.system(size: 34))
                                .foregroundStyle(LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                                        Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 0.88),
                                    ],
                                    startPoint: UnitPoint(x: 0.5, y: 0),
                                    endPoint: UnitPoint(x: 0.5, y: 1)
                                ))
                                .padding(20)
                        }
                    }
                    .shadow(color: .black.opacity(0.35), radius: 18.02564, x: 7.21026, y: 10.81538)
                    .padding(.top, 30)
                    .padding(.top, UIDevice.current.userInterfaceIdiom == .pad ? 40 : 0)
                    Spacer()
                }
            }
//            .fullScreenCover(isPresented: $showPremium, content: {
//                PremiumView()
//            })
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
            .sheet(isPresented: $isImagePickerPresented) {
                CustomPickerView( viewModel: viewModel, selectedImages: $viewModel.selectedImages, shouldNavigateTo: $isActive)
            }
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
