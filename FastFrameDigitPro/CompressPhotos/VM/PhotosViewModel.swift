//
//  PhotosViewModel.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import Foundation
import SwiftUI
import PhotosUI

class PhotosViewModel: ObservableObject {
    @Published var selectedImages: [Photo]
    @Published var compressionValue: Double = 0.5
    @Published var sizeSavings: Double = 0.0
    @Published var navigateToCompressAnimation: Bool = false
    @Published var progress: Double = 0
    @Published var compressing: Bool = false
    @Published var lastSliderValue: Double = 0.5
    @Published var compressedImages = [UIImage]()
    @Published var originalImageSize: Double = 0.0
    @Published var compressedImageSize: Double = 0.0
    @Published var fetched_photos: [Photo] = []
    @Published var photoAccessGranted: Bool = false
    @Published var displaying_photos: [Photo]?
    @Published var sliderValue = 50.0

    private let compressionUpdateDelay = 0.1
    private let compressionQueue = DispatchQueue(label: "image.compression.queue", qos: .userInitiated)
    private var sliderTimer: Timer?
    
    init(selectedImages: [Photo], compressedImages: [UIImage]) {
        self.selectedImages = selectedImages
        self.compressedImages = compressedImages
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            photoAccessGranted = true
            // fetching photos...
            fetched_photos = fetchPhotosFromGallery()
            // storing it in displaying photos...
            displaying_photos = fetched_photos
        } else if status == .denied || status == .restricted {
            // not authorized
            photoAccessGranted = false
        } else {
            // request authorization
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.photoAccessGranted = true
                        // fetching photos...
                        self.fetched_photos = self.fetchPhotosFromGallery()
                        // storing it in displaying photos...
                        self.displaying_photos = self.fetched_photos
                    } else {
                        self.photoAccessGranted = false
                    }
                }
            }
        }
    }
    
    func formatSliderValue(value: Double) -> String {
        let formattedValue = String(format: "%.0f", self.sliderValue)
        return formattedValue
    }

    func PhotoQualityString() -> String {
        let value = self.lastSliderValue
        var text = ""
        if value <= 0.1 {
            text = "Great"
        } else if value <= 0.3 {
            text = "Good"
        } else if value <= 0.5 {
            text = "Acceptable"
        } else if value <= 0.7 {
            text = "Reasonable"
        } else  {
            text = "Bad"
        }
        return text
    }

    func compressImages() {
        compressing = true
        let totalCount = Double(self.selectedImages.count)
        DispatchQueue.global(qos: .userInitiated).async {
            let imageManager = PHImageManager.default()
            let requestOptions = PHImageRequestOptions()
            requestOptions.version = .current
            requestOptions.isSynchronous = true
            for (index, photo) in self.selectedImages.enumerated() {
                imageManager.requestImage(for: photo.asset, targetSize: CGSize(width: photo.asset.pixelWidth, height: photo.asset.pixelHeight), contentMode: .aspectFill, options: requestOptions, resultHandler: { image, _ in
                    if let image = image {
                        let originalData = image.jpegData(compressionQuality: 1)
                        let originalSize = Double(originalData?.count ?? 0) / (1024 * 1024) // size in MB
                        let result = compressImage(image: image, quality: CGFloat(1 - self.compressionValue))
                        if let compressedImage = result.image {
                            DispatchQueue.main.async {
                                self.compressedImages.append(compressedImage)  // add the compressed image to the array
                            }
                        }
                        let compressedSize = result.size // assuming compressImage returns a tuple where size is the compressed image size
                        DispatchQueue.main.async {
                            self.progress = Double(index+1) / totalCount * 100.0
                            if self.progress >= 100.0 {
                                print(self.progress)
                                self.compressing = false
                                self.navigateToCompressAnimation = true
                            }
                        }
                    }
                })
            }
        }
    }
    
    func fetchPhotosFromGallery() -> [Photo] {
          let requestOptions = PHImageRequestOptions()
          requestOptions.isSynchronous = false
          requestOptions.deliveryMode = .highQualityFormat
          let fetchOptions = PHFetchOptions()
          fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
          let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
          var photos: [Photo] = []
          if fetchResult.count > 0 {
              for i in 0..<fetchResult.count {
                  let asset = fetchResult.object(at: i)
                  photos.append(Photo(asset: asset))
              }
          }
          return photos
      }

    func clearCompressedImages() {
            compressedImages = []
        }

    func calculateEstimatedSizeSavings() {
        var totalOriginalSize: Double = 0
        var totalCompressedSize: Double = 0
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.version = .current
        requestOptions.isSynchronous = true
        for photo in selectedImages {
            getFileSize(asset: photo.asset) { size in
                totalOriginalSize += size
                DispatchQueue.main.async {
                                self.originalImageSize = totalOriginalSize
                            }
            }
            imageManager.requestImage(for: photo.asset, targetSize: CGSize(width: photo.asset.pixelWidth, height: photo.asset.pixelHeight), contentMode: .aspectFill, options: requestOptions, resultHandler: { image, _ in
                if let image = image {
                  
                    let estimatedCompressedData = image.jpegData(compressionQuality: CGFloat(1 - self.compressionValue))
                    let estimatedCompressedSize = Double(estimatedCompressedData?.count ?? 0) / (1024 * 1024) // size in MB
                    totalCompressedSize += estimatedCompressedSize
                    DispatchQueue.main.async {
                                      self.compressedImageSize = totalCompressedSize
                                  }
                }
            })
        }
        DispatchQueue.main.async {
            // Avoid negative savings
            self.sizeSavings = max(0, totalOriginalSize - totalCompressedSize)
        }
    }

    func scheduleSizeSavingsCalculation() {
        sliderTimer?.invalidate()
        sliderTimer = Timer.scheduledTimer(withTimeInterval: compressionUpdateDelay, repeats: false) { _ in
            self.calculateEstimatedSizeSavings()
        }
    }

    func getFileSize(asset: PHAsset, completionHandler: @escaping ((_ fileSize: Double) -> Void)) {
        if asset.mediaType == .image {
            let resources = PHAssetResource.assetResources(for: asset)
            if let resource = resources.first {
                let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
                if let size = unsignedInt64 {
                    completionHandler(Double(size) / (1024 * 1024)) // Convert bytes to MB
                }
            }
        }
    }
    
    
    func replaceFilesWithImages(assets: [PHAsset], newImages: [UIImage]) {

        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(PHAsset.fetchAssets(withLocalIdentifiers: assets.map{$0.localIdentifier}, options: nil) as NSFastEnumeration)
        }) {(success, error) in
            DispatchQueue.main.async {
                if success {
                    newImages.forEach({
                        UIImageWriteToSavedPhotosAlbum($0, nil, nil, nil)
                    })
                    let compressedCount = UserDefaults.standard.integer(forKey: "compress-count")
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(newImages.count + compressedCount, forKey: "compress-count")
                        UserDefaults.standard.synchronize()
                    }
                } else {
                    print("Error deleting images: \(error?.localizedDescription ?? "unknown error")")
                }
            }
        }
    }
    
    func saveCompressedImages(images: [UIImage]) {
        images.forEach { UIImageWriteToSavedPhotosAlbum($0, nil, nil, nil) }
        let compressedCount = UserDefaults.standard.integer(forKey: "compress-count")
        UserDefaults.standard.set(images.count + compressedCount, forKey: "compress-count")
        UserDefaults.standard.synchronize()
    }

}


struct SingleImageLoaderView: View {
    @StateObject var imageLoader = ImageLoaderAndCache()
    var photo: Photo
    
    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage:  image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.height > 680 ? 226 : 206, height: UIScreen.main.bounds.height > 680 ? 200 : 180)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.25), radius: 6.5, x: 0, y: 0)
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

struct PhotoView: View {
    var photo: Photo
    
    var body: some View {
        SingleImageLoaderView(photo: photo)
    }
}


func compressImage(image: UIImage?, quality: CGFloat) -> (image: UIImage?, size: Double) {
    guard let imageData = image?.jpegData(compressionQuality: quality) else {
        return (nil, 0)
    }
    let sizeInBytes = imageData.count
    let sizeInKB = Double(sizeInBytes) / 1024.0
    let sizeInMB = sizeInKB / 1024.0
    return (UIImage(data: imageData), sizeInMB)
}

struct Photo: Identifiable, Hashable, Equatable {
    var id = UUID().uuidString
    let asset: PHAsset
    
    // Define how to hash this type
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Define equality for this type
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
}

