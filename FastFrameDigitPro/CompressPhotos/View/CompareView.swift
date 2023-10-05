//
//  CompareView.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import SwiftUI
import Photos
import SwiftUIIntrospect

struct CompareView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PhotosViewModel
    var simultaneouslyScrollViewHandler = SimultaneouslyScrollViewHandler()
    @ObservedObject var ui = UIDetector.shared
    @ObservedObject var vmAlert: ContentModel
    @State var showShareAlbum = false
    
    var body: some View {
        ZStack {
            customBackgroundGradient()
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding(12)
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
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        showShareAlbum = true
                    } label: {
                        Image("share")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding(6)
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
                .padding(.bottom)
                .padding(.horizontal)
                Text("Before")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                if viewModel.selectedImages.count == 1 {
                    HStack {
                        Spacer()
                        AsyncImageFromAsset(asset: viewModel.selectedImages[0].asset)
                        Spacer()
                    }
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.selectedImages, id: \.id) { photo in
                                AsyncImageFromAsset(asset: photo.asset)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .introspect(.scrollView) {
                        simultaneouslyScrollViewHandler.register(scrollView: $0)
                    }
                }
                Spacer()
                Image("Arrow")
                    .padding(.vertical)
                Text("After")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                Spacer()
                if viewModel.selectedImages.count == 1 {
                    HStack {
                        Spacer()
                        AsyncImageFromAsset(asset: viewModel.selectedImages[0].asset)
                        Spacer()
                    }
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.compressedImages.indices, id: \.self) { index in
                                Image(uiImage: viewModel.compressedImages[index])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: CGFloat(( ui.device == .phone) ? UIScreen.main.bounds.height > 680 ? CGFloat(125) : CGFloat(115) : 175), height: CGFloat(( ui.device == .phone) ? UIScreen.main.bounds.height > 680 ? CGFloat(125) : CGFloat(140) : 210))
                                    .cornerRadius(6)
                                    .shadow(color: .black.opacity(0.25), radius: 5.2706, x: 0, y: 0)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, UIDevice.current.userInterfaceIdiom == .pad ? 70 : 40)
                    }
                    .introspect(.scrollView) {
                        simultaneouslyScrollViewHandler.register(scrollView: $0)
                    }
                }
                Spacer()
            }
        }
        .fullScreenCover(isPresented: self.$showShareAlbum, content: {
            ShareSheet(items: viewModel.compressedImages)
        })
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct AsyncImageFromAsset: View {
    @State private var image: UIImage? = nil
    let asset: PHAsset
    @ObservedObject var ui = UIDetector.shared
    
    var body: some View {
        Group {
            if let img = image {
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: CGFloat(( ui.device == .phone) ? UIScreen.main.bounds.height > 680 ? CGFloat(125) : CGFloat(115) : 175), height: CGFloat(( ui.device == .phone) ? UIScreen.main.bounds.height > 680 ? CGFloat(125) : CGFloat(140) : 210))
                    .cornerRadius(6)
                    .shadow(color: .black.opacity(0.25), radius: 5.2706, x: 0, y: 0)
            } else {
                ProgressView()
            }
        }
        .onAppear(perform: loadImageFromAsset)
    }
    private func loadImageFromAsset() {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: CGFloat(( ui.device == .phone) ? 200 : 900), height: CGFloat(( ui.device == .phone) ? 200 : 900)), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
            self.image = result
        })
    }
}

