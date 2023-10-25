//
//  UploadImageCapacity.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/3/20.
//

import Foundation
import SwiftyJSON
import Combine
import CSFileKit
import CSUtilities

protocol UploadImageCapacity: AnyObject {
    var assembly: FieldAssembly { get }
    var cancellableSet: Set<AnyCancellable> { get set}
    func uploadPhoto(data: JSON)
}

extension UploadImageCapacity {
    
    func uploadPhotoImage(completion: @escaping Action1<String?>) {
        showImagePicker { [weak self] image in
            guard let image = image else {
                completion(nil)
                return
            }
            self?.saveImage(image, completion: completion)
        }
    }
    
    func showImagePicker(callback: @escaping Action1<UIImage?>) {
        assembly.photoManager().showImagePicker(callback: { arg in
            callback(arg)
        })
    }
    
    func updateMyPhoto(completion: @escaping Action1<String?>) {
        let facetimeClient = assembly.resolve(type: FaceTimeClient.self)
        facetimeClient.onCapturePhotoChange.first().sink { serveUrl in
            completion(serveUrl)
        }.store(in: &cancellableSet)
        facetimeClient.capturePhoto()
    }

    func saveImage(_ image: UIImage, completion: @escaping Action1<String?>) {
        Task {
            do {
                let localUrl = try await FileTask.saveImage(image: image)
                let serveUrl = try await UploadTask.uploadImage(path: localUrl)
                await MainActor.run {
                    completion(serveUrl)
                }
            } catch {
                completion(nil)

            }
        }
    }
}
