//
//  SelectedFilesView.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import SwiftUI

struct SelectedFilesView: View {
    @ObservedObject var viewModel: PhotosViewModel
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var ui = UIDetector.shared
    @State private var showResults = false
    @State var showCompare = false
    @ObservedObject var vmAlert: ContentModel
    @State var showShareAlbum = false
    var singleImageView: some View {
        PhotoView(photo: viewModel.selectedImages.first!)
            .aspectRatio(contentMode: .fit)
            .cornerRadius(12)
            .padding(.horizontal)
            .shadow(color: .black.opacity(0.25), radius: 6.5, x: 0, y: 0)
        
        
    }
    
    var multipleImageView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            let rows = Array(repeating: GridItem(.fixed(UIScreen.main.bounds.height > 680 ? CGFloat(130) : CGFloat(120)), spacing: CGFloat((ui.device == .phone) ? 5 : 110)), count: showResults ? 1 : 2)
            LazyHGrid(rows: rows, spacing: 10) {
                imageRows
            }
            .padding(CGFloat((ui.device == .phone) ? 16 : 32))  // Apply padding to all sides
        }
        
        .frame(height: CGFloat((ui.device == .phone) ? (showResults ? 100 : 230) : (showResults ? 300 : 500))) // Specify a fixed height
    }
    
    
    var imageRows: some View {
        ForEach(viewModel.selectedImages, id: \.id) { photo in
            ImageLoaderView(photo: photo)
            
        }
    }
    
    
    
    var body: some View {
        ZStack {
            
            customBackgroundGradient()
                .ignoresSafeArea()
            NavigationLink("", isActive: $showCompare) {
                CompareView(viewModel: viewModel, vmAlert: vmAlert)
            }
            VStack {
                HStack {
                    Button {
                        viewModel.selectedImages = []
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: UIScreen.main.bounds.height > 680 ? 20 : 18))
                            .padding(UIScreen.main.bounds.height > 680 ? 12 : 8)
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
                    .frame(width: 40)
                    Spacer()
                    Text("Compress")
                        .font(.system(size: UIScreen.main.bounds.height > 680 ? 24 : 20))
                        .foregroundColor(.white)
                    Spacer()
                    
                    if showResults {
                        Button {
                            showShareAlbum = true
                        } label: {
                            Image("share")
                                .foregroundColor(.white)
                                .font(.system(size: UIScreen.main.bounds.height > 680 ? 20 : 18))
                                .padding(UIScreen.main.bounds.height > 680 ? 6 : 4)
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
                    } else {
                        Image(systemName: "xmark")
                            .frame(width: 40)
                            .opacity(0)
                    }
                }
                .padding(.horizontal)
                
                if viewModel.selectedImages.count == 1 {
                    singleImageView
                        .padding(.top,UIScreen.main.bounds.height > 680 ? CGFloat(16) : CGFloat(0))
                } else {
                    multipleImageView
                        .padding(.top,UIScreen.main.bounds.height > 680 ? CGFloat(16) : CGFloat(0))
                    
                }
                
                if !showResults {
                    HStack {
                        Text("Total: \(viewModel.originalImageSize, specifier: "%.2f") MB")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                        Spacer()
                    }
                    .padding(.horizontal, CGFloat((ui.device == .phone) ? 16 : 32))
                    .padding(.top,  UIScreen.main.bounds.height > 680 ? 16 : 10 )
                    Text("Select compress level")
                        .font(.system(size:   UIScreen.main.bounds.height > 680 ? 18 : 16))
                        .foregroundColor(.white)
                        .padding(.top, UIScreen.main.bounds.height > 680 ? 16 : 10)
//                    HStack {
//                        Text(" \(Int(viewModel.lastSliderValue * 100))" + "%")
//                            .font(.system(size: UIScreen.main.bounds.height > 680 ? 24 : 20))
//                            .foregroundColor(.white)
//                            .padding(.horizontal, CGFloat((ui.device == .phone) ? 0 : 130))
                        Spacer()
//                    }
//                    .padding(UIScreen.main.bounds.height > 680 ? 16 : 8)
                    HStack {
                        Text("Photo quality: \(viewModel.PhotoQualityString())")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                        Spacer()

                    }
                    .padding(.horizontal, CGFloat((ui.device == .phone) ? 16 : 130))
                    CustomSlider(value: $viewModel.compressionValue, in: 0.0...1.0, step: 0.01)
                        .frame(height: UIScreen.main.bounds.height > 680 ? 30 : 25)
                        .padding(.horizontal, CGFloat((ui.device == .phone) ? 16 : 130))
                        .padding(.top, UIScreen.main.bounds.height > 680 ? 16 : 10)
                        .onChange(of: viewModel.compressionValue) { newValue in
                            let roundedValue = (Double(round(newValue*10)/10))
                            viewModel.compressionValue = roundedValue
                            viewModel.lastSliderValue = roundedValue
                            viewModel.scheduleSizeSavingsCalculation() // Schedule size savings calculation with a delay
                            print(viewModel.lastSliderValue)                    }
                    Spacer()
                    Button {
                        viewModel.clearCompressedImages()
                        viewModel.compressImages()
                        showResults = true
                    } label: {
                        Text("Compress")
                            .frame(width: UIScreen.main.bounds.height > 680 ? (UIDevice.current.userInterfaceIdiom == .pad ? 260 : 165) : 135, height: UIScreen.main.bounds.height > 680 ? (UIDevice.current.userInterfaceIdiom == .pad ? 80 : 55) : 50)
                            .foregroundStyle(LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 0.88),
                                ],
                                startPoint: UnitPoint(x: 0.5, y: 0),
                                endPoint: UnitPoint(x: 0.5, y: 1)
                            ))
                            .background(
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: Color(red: 0.08, green: 0.08, blue: 0.08), location: 0.00),
                                            Gradient.Stop(color: Color(red: 0.18, green: 0.2, blue: 0.21), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 0.82, y: 0.88),
                                        endPoint: UnitPoint(x: 0.2, y: 0.11)
                                    )
                            
                                    .cornerRadius(40)
                                    .shadow(color: .black.opacity(0.35), radius: 18.02564, x: 7.21026, y: 10.81538)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 40)
                                            .inset(by: 0.9)
                                            .stroke(Color(red: 0.16, green: 0.17, blue: 0.18), lineWidth: 1.8)
                                    ))
                    }
                    .padding(.bottom)
                 
                } else {
                    Spacer()
                    Text("Completed!")
                        .foregroundColor(.white)
                        .padding(.vertical, UIScreen.main.bounds.height > 680 ? 16 : 10)
                        .font(.system(size: 18).weight(.medium))
                    
                    Text("Your photos are compressed succesfully")
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                        .frame(width: UIScreen.main.bounds.height > 680 ? 270 : 250, alignment: .center)
                        .padding(.bottom)
                    
                    HStack {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 0.88),
                                ],
                                startPoint: UnitPoint(x: 0.5, y: 0),
                                endPoint: UnitPoint(x: 0.5, y: 1)
                            ))
                        Text("Original size: \(viewModel.originalImageSize, specifier: "%.2f") MB")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                    }
                    .padding(.bottom)
                    HStack {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 0.88),
                                ],
                                startPoint: UnitPoint(x: 0.5, y: 0),
                                endPoint: UnitPoint(x: 0.5, y: 1)
                            ))
                        Text("Reduced size: \(viewModel.compressedImageSize, specifier: "%.2f") MB")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                    }
                    .padding(.bottom)
                    HStack {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 0.88),
                                ],
                                startPoint: UnitPoint(x: 0.5, y: 0),
                                endPoint: UnitPoint(x: 0.5, y: 1)
                            ))
                        Text("Saved: \(viewModel.originalImageSize - viewModel.compressedImageSize, specifier: "%.2f") MB")
                            .font(.system(size: 16))
                            
                    }
                    .padding(.bottom)
                    .foregroundStyle(LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 0.88),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                    ))
                    Spacer()
                    HStack {
                        Button {
                            
                            showCompare = true
                        } label: {
                            Text("Compare")
                                .frame(width: UIScreen.main.bounds.height > 680 ? (UIDevice.current.userInterfaceIdiom == .pad ? 260 : 165) : 135, height: UIScreen.main.bounds.height > 680 ? (UIDevice.current.userInterfaceIdiom == .pad ? 80 : 55) : 50)
                                .foregroundStyle(Color(red: 0.74, green: 0.74, blue: 0.74))
                                .background(
                                        LinearGradient(
                                            stops: [
                                                Gradient.Stop(color: Color(red: 0.08, green: 0.08, blue: 0.08), location: 0.00),
                                                Gradient.Stop(color: Color(red: 0.18, green: 0.2, blue: 0.21), location: 1.00),
                                            ],
                                            startPoint: UnitPoint(x: 0.82, y: 0.88),
                                            endPoint: UnitPoint(x: 0.2, y: 0.11)
                                        )
                                        .cornerRadius(40)
                                        .shadow(color: .black.opacity(0.35), radius: 18.02564, x: 7.21026, y: 10.81538)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 40)
                                                .inset(by: 0.9)
                                                .stroke(Color(red: 0.16, green: 0.17, blue: 0.18), lineWidth: 1.8)
                                        ))
                        }
                        Spacer()
                        Button {
                   
                            vmAlert.showSavePopup = true
                        } label: {
                            Text("Save")
                                .frame(width: UIScreen.main.bounds.height > 680 ? (UIDevice.current.userInterfaceIdiom == .pad ? 260 : 165) : 135, height: UIScreen.main.bounds.height > 680 ? (UIDevice.current.userInterfaceIdiom == .pad ? 80 : 55) : 50)
                                .foregroundStyle(LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                                        Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 0.88),
                                    ],
                                    startPoint: UnitPoint(x: 0.5, y: 0),
                                    endPoint: UnitPoint(x: 0.5, y: 1)
                                ))
                                .background(
                                        LinearGradient(
                                            stops: [
                                                Gradient.Stop(color: Color(red: 0.08, green: 0.08, blue: 0.08), location: 0.00),
                                                Gradient.Stop(color: Color(red: 0.18, green: 0.2, blue: 0.21), location: 1.00),
                                            ],
                                            startPoint: UnitPoint(x: 0.82, y: 0.88),
                                            endPoint: UnitPoint(x: 0.2, y: 0.11)
                                        )
                                        .cornerRadius(40)
                                        .shadow(color: .black.opacity(0.35), radius: 18.02564, x: 7.21026, y: 10.81538)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 40)
                                                .inset(by: 0.9)
                                                .stroke(Color(red: 0.16, green: 0.17, blue: 0.18), lineWidth: 1.8)
                                        ))
                        }
                    }
                    .padding(.horizontal, CGFloat((ui.device == .phone) ? 16 : 130))
                   // .padding(.top, CGFloat((ui.device == .phone) ? 0 : 130))
Spacer()
                }
                    
                
                Spacer()
                
                
            }
            .blur(radius: vmAlert.showSavePopup ? 2 : 0)
        }
        .fullScreenCover(isPresented: self.$showShareAlbum, content: {
            ShareSheet(items: viewModel.compressedImages)
            })
        .navigationBarHidden(true)
        .onAppear(perform: viewModel.calculateEstimatedSizeSavings)
        
          
            .overlay {
                if vmAlert.showSavePopup {
                    SavePopup(vm: vmAlert, viewModel: viewModel)
                }
            }
    }
}



struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}
