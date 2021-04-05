//
//  PhotosViewModel.swift
//  Photos
//
//  Created by An Nguyễn on 4/1/21.
//

import SwiftUI
import Combine
import Photos
import PhotosUI

final class PhotosViewModel: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()
    @Published var images: [UIImage] = []
    
    
    init() {
        $images.sink { (images) in
            print(images.count)
        }.store(in: &subscriptions)
    }
    
    func requestAuthorization() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                self.getPhotos()
                print("authorized")
            case .denied:
                print("denied")
            case .limited:
                self.getPhotos()
                print("limited")
            case .notDetermined:
                print("notDetermined")
            case .restricted:
                print("restricted")
            @unknown default:
                print("default")
            }
        }
    }
    
    func getPhotos() {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        guard authorizationStatus == .authorized || authorizationStatus == .limited else {
            requestAuthorization()
            return
        }
        let options = PHFetchOptions()
        options.fetchLimit = 100
        let results = PHAsset.fetchAssets(with: options)
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        for index in 0..<results.count {
            PHImageManager.default().requestImage(for: results.object(at: index) as PHAsset, targetSize: .init(width: 500, height: 500), contentMode: .aspectFill, options: requestOptions) { (image, _) in
                guard let image = image else { return }
                self.images += [image]
            }
        }
    }
}
