//
//  SavePopup.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import SwiftUI
import UIKit

struct SavePopup: View {
    @ObservedObject var vm: ContentModel
    @State private var showAlert = false
    @ObservedObject var viewModel: PhotosViewModel
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.1)
                .ignoresSafeArea()
            VStack {
                Text("Save compressed photos")
                    .padding(.bottom, UIDevice.current.userInterfaceIdiom == .pad ? 32 : 16)
                    .foregroundColor(.white)
                HStack(spacing: UIDevice.current.userInterfaceIdiom == .pad ? 40 : 25) {
                    Button {
                        viewModel.replaceFilesWithImages(assets: viewModel.selectedImages.map { $0.asset }, newImages: viewModel.compressedImages)
                        vm.showSavePopup = false
                    } label: {
                        Text("Delete Originals")
                    }
                    .accentColor(.white)
                    Button {
                        showAlert = true
                    } label: {
                        Text("Keep Originals")
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
            }
            .padding(UIDevice.current.userInterfaceIdiom == .pad ? 60  : 40)
            .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 60 : 0)
            .background(.ultraThinMaterial)
            .cornerRadius(40)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Save compressed photos"),
                      message: Text("Do you want to save compressed photos?"),
                      primaryButton: .default(Text("Save")) {
                    viewModel.saveCompressedImages(images: viewModel.compressedImages)
                    vm.showSavePopup = false
                },
                      secondaryButton: .cancel())
            }
        }
    }
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
