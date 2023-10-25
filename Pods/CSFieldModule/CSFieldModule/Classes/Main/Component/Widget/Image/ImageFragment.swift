//
//  ImageFragment.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/3/16.
//

import Foundation
import ObjectMapper
import Combine
import SwiftyJSON

class ImageFragment: WidgetFragment {
    
    @Published var url: String?
    var align: NSTextAlignment = .center
    
    override func mapping(map: ObjectMapper.Map) {
        align     <- (map["align"], AlignTransform())
    }
    
    override func update(full: JSON, change: JSON) {
        if let url = change["url"].string {
            self.url = url
        }
    }
    
    func syncPhoto(_ url: String) {
        syncData(value: ["url": url])
    }

//    func updateMyPhoto() {
//        let facetimeClient = assembly.resolve(type: FaceTimeClient.self)
//        facetimeClient.onCapturePhotoChange.first().sink { [weak self] serveUrl in
//            guard let self = self else { return }
//            guard let serveUrl = serveUrl else { return }
//            self.syncPhoto(serveUrl)
//        }.store(in: &cancellableSet)
//        facetimeClient.capturePhoto()
//    }
    
    
    
    override var height: CGFloat {
        225
    }
    
    
}

extension ImageFragment: UploadImageCapacity {
    func uploadPhoto(data: SwiftyJSON.JSON) {
        
        uploadPhotoImage { [weak self] imageUrl in
            if let imageUrl = imageUrl {
                self?.syncPhoto(imageUrl)
            } else {
                
            }
        }
        
    }
}
