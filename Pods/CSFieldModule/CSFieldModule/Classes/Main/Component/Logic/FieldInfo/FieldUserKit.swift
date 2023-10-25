//
//  RTCUser.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/12/5.
//

import Foundation
import ComeSocialRTCService
import come_social_media_tools_ios
import CSAccountManager
import SwiftyJSON

class FieldUserKit {
    
    var info: FieldUserModel
    let assembly: FieldAssembly
    
    var displayName: String {
        return  info.name
    }
    
    private weak var renderView: SizeAdaptiveYUVRenderView?
    @Published private(set) var isRendering = false
    @Published private(set) var photoUrl: String?

    var id: UInt {
        return info.id
    }
    

    var isLocal: Bool {
        return info.id == AccountManager.shared.id
    }
    
    init(userInfo: FieldUserModel, assembly: FieldAssembly) {
        self.info = userInfo
        self.assembly = assembly
        let prop = assembly.properties().getUserPropety(id: userInfo.id)
        syncUser(data: prop)
    }
    
    func updateInfo(info: FieldUserModel) {
        self.info = info
    }
    
    func syncUser(data: JSON) {
        
        if let videoOpen = data["video"].bool {
            self.isRendering = videoOpen
        }
        
        if let photoUrl = data["photo"].string {
            self.photoUrl = photoUrl
        }
    }
}
