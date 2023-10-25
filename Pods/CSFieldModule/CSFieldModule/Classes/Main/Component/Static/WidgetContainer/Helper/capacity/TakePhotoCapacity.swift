//
//  TakePhotoCapacity.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/3/21.
//

import Foundation
import SwiftyJSON
import Combine
import CSFileKit
import CSUtilities


protocol TakePhotoCapacity: AnyObject {
    var assembly: FieldAssembly { get }
    var cancellableSet: Set<AnyCancellable> { get set}
    func takePhoto(data: JSON)
}

extension TakePhotoCapacity {
    
    func takingSelfie(completion: @escaping Action1<String?>) {
        let facetimeClient = assembly.resolve(type: FaceTimeClient.self)
        facetimeClient
            .onCapturePhotoChange
            .first()
            .sink(receiveValue: completion)
            .store(in: &cancellableSet)
        facetimeClient.capturePhoto()
    }
}
