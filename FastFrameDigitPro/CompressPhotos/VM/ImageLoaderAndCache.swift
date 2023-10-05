//
//  ImageLoaderAndCache.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import Foundation
import SwiftUI
import Photos
import Combine

class ImageLoaderAndCache: ObservableObject {
    @ObservedObject var ui = UIDetector.shared
    @Published var image: UIImage?
    private static let cache = NSCache<NSString, UIImage>()
    private var cancellable: AnyCancellable?
    private func cache(_ image: UIImage?, for id: String) {
        ImageLoaderAndCache.cache.setObject(image ?? UIImage(), forKey: id as NSString)
    }
    private func cachedImage(for id: String) -> UIImage? {
        return ImageLoaderAndCache.cache.object(forKey: id as NSString)
    }
    
    func load(asset: PHAsset) {
        let id = asset.localIdentifier
        if let cached = cachedImage(for: id) {
            image = cached
            return
        }
        
        cancellable = Future<UIImage?, Never> { promise in
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            option.isSynchronous = false
            option.resizeMode = .exact // for original image size
            option.deliveryMode = .highQualityFormat
            let targetSize =  CGSize(width: CGFloat(( self.ui.device == .phone) ? 500 : 900), height: CGFloat(( self.ui.device == .phone) ? 500 : 900)) // adjust this to your need
            manager.requestImage(for: asset,
                                 targetSize: targetSize,
                                 contentMode: .aspectFit,
                                 options: option,
                                 resultHandler: { (image, _) in
                DispatchQueue.main.async {
                    promise(.success(image))
                }
            })
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { _ in },
              receiveValue: { [weak self] image in
            self?.cache(image, for: id)
            self?.image = image
        })
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    func removeImagesFromCache(for assets: [PHAsset]) {
        for asset in assets {
            let id = asset.localIdentifier
            ImageLoaderAndCache.cache.removeObject(forKey: id as NSString)
        }
    }
    
    func clearCache() {
        ImageLoaderAndCache.cache.removeAllObjects()
        print("Cache cleared.")
    }
}

