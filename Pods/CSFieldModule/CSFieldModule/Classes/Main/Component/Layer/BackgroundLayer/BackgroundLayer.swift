//
//  BackgroundLayer.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/2/6.
//

import Foundation
import SwiftyJSON

class BackgroundLayer: FieldBaseView {
    
    @Published var video: String?
    @Published var audio: String?

    override func initialize() {
        let playerVideoView = assembly.resolve(type: VideoPlayerView.self)
        addSubview(playerVideoView)
        playerVideoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func updateRoomInfo(_ info: JSON) {
        video = info["background_image"].string
//        audio = info["background_music"].string
    }
}
