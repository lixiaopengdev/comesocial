//
//  LivePhotoFragment.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/5/26.
//

import Foundation
import ObjectMapper
import CSUtilities
import UIKit
import Combine
import SwiftyJSON
import CSAccountManager

class LivePhotoFragment: WidgetFragment {
    
    class PhotoInfo {
        let id: UInt
        let name: String
        let avatar: String

        var fore: String?
        var back: String?
        var time: TimeInterval?
        
        init(id: UInt, name: String, avatar: String) {
            self.id = id
            self.name = name
            self.avatar = avatar
        }
    }
    
    var photos: [PhotoInfo] = []
    var photosData: JSON = JSON()
    var updatePublisher = CurrentValueSubject<[PhotoInfo], Never>([])
    
    override func initialize() {
        assembly
            .usersManager()
            .$users
            .sink { [weak self] users in
                self?.photos = users.map({ user in
                    return PhotoInfo(id: user.id, name: user.displayName, avatar: user.info.avatar ?? "")
                })
                self?.updatePhoto()
            }
            .store(in: &cancellableSet)
    }
    
    override func update(full: JSON, change: JSON) {
        photosData = full
        updatePhoto()
    }
    
    func syncPhoto(back: String, fore: String) {
        let mineId = AccountManager.shared.id
        syncData(value: [String(mineId): ["back": back, "fore": fore, "time": Date().timeIntervalSince1970]])
    }
    
    func updatePhoto() {
        for photo in photos {
            let photoDict = photosData[String(photo.id)]
            photo.fore = photoDict["fore"].string
            photo.back = photoDict["back"].string
            photo.time = photoDict["time"].double
        }
        updatePublisher.send(photos)
    }
    
    func uploadMyPhoto() {
        let facetimeClient = assembly.resolve(type: FaceTimeClient.self)
        facetimeClient
            .onCapturePhotoChange
            .first()
            .sink { [weak self] serveUrl in
                guard let serveUrl = serveUrl else { return }
                self?.syncPhoto(back: serveUrl, fore: "")
            }
            .store(in: &cancellableSet)
        facetimeClient.capturePhoto()
    }
    
    override var height: CGFloat {
        
        return 442
    }
    
    
}
