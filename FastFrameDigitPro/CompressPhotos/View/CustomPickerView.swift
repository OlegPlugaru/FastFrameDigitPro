//
//  CustomPickerView.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import SwiftUI
import Photos

struct CustomPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PhotosViewModel
    @Binding var selectedImages: [Photo]
    @Binding var shouldNavigateTo: Bool
    @ObservedObject var ui = UIDetector.shared
    let maxSelectionLimit: Int = 30
    
    var body: some View {
        NavigationView {
            if viewModel.photoAccessGranted {
            ScrollView {
                LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 15), count: 3), spacing: 15) {
                    ForEach(viewModel.fetched_photos) { photo in
                        GeometryReader { proxy in
                            ImageLoaderView(photo: photo)
                                .scaledToFill()
                                .frame(width: proxy.size.width, height: proxy.size.height)
                                .clipped()
                                .contentShape(Rectangle())
                                .background(Color(red: 0.65, green: 0.65, blue: 0.65))
                                .cornerRadius(7)
                                .shadow(color: .black.opacity(0.25), radius: 6.5, x: 0, y: 0)
                                .overlay(
                                    selectedImages.contains(where: { $0.id == photo.id }) ?
                                        VStack(alignment: .trailing) {
                                            Spacer()
                                            HStack {
                                                Spacer()
                                                Image(systemName: "checkmark.circle.fill").foregroundColor(.blue)
                                                    .padding(3)
                                            }
                                        } : nil
                                )
                                .onTapGesture {
                                    if selectedImages.count >= maxSelectionLimit && !selectedImages.contains(where: { $0.id == photo.id }) {
                                        // Do nothing if the maximum limit of 10 photos is reached and the tapped photo is not already selected.
                                    } else {
                                        if let index = selectedImages.firstIndex(where: { $0.id == photo.id }) {
                                            selectedImages.remove(at: index)
                                        } else {
                                            selectedImages.append(photo)
                                        }
                                    }
                                }
                        }
                        .aspectRatio(1, contentMode: .fit)
                    }
                }
                .padding()
            }
            .background{
                Color(red: 0.12, green: 0.13, blue: 0.14)
                    .ignoresSafeArea()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "xmark")
                        .padding(8)
                        .foregroundColor(.white)
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
                
            }, trailing: HStack(spacing: 5) {
                Text("Selected: \(selectedImages.count)/\(maxSelectionLimit)")
                    .font(.subheadline)
                    .foregroundColor(selectedImages.count >= maxSelectionLimit ? .red : .gray)
                Button {
                    shouldNavigateTo = true
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Done")
                        .font(Font.custom("Montserrat-Regular", size: 16))
                        .foregroundStyle(LinearGradient(
                            stops: [
                            Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 0.88),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                            ))
                }
                .disabled(selectedImages.isEmpty || selectedImages.count > maxSelectionLimit)
            })
            } else {
                           VStack {
                               Text("Access to Photos Needed")
                                   .font(.headline)
                               Text("Our app needs access to photos to perform the image compression. Please grant the permission in settings.")
                                   .font(.subheadline)
                                   .multilineTextAlignment(.center)
                                   .padding(.bottom)
                               Button(action: {
                                   if let settingsURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsURL) {
                                       UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                                   }
                               }) {
                                   Text("Go to settings")
                                       .underline()
                                       .foregroundColor(.blue)
                               }
                           }
                           .padding()
                       }
                   
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ImageLoaderView: View {
    @StateObject var imageLoader = ImageLoaderAndCache()
    @ObservedObject var ui = UIDetector.shared
    var photo: Photo
    
    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage:  image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: CGFloat(( ui.device == .phone) ? UIScreen.main.bounds.height > 680 ? CGFloat(130) : CGFloat(120) : 220), height:  CGFloat(( ui.device == .phone) ? UIScreen.main.bounds.height > 680 ? CGFloat(120) : CGFloat(110) : 220))
                    .cornerRadius(5)
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 4, y: 4)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            imageLoader.load(asset: photo.asset)
        }
        .onDisappear {
            imageLoader.cancel()
        }
    }
}

