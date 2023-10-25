//
//  BaseVideoFragment.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/3/16.
//

import Foundation


import Foundation
import ObjectMapper
import CSUtilities
import UIKit
import JSEngineKit
import SwiftyJSON
import Combine
import CSAccountManager
import come_social_media_tools_ios
import CSMediator

class FaceTimeFragment: WidgetFragment, FaceTimeClientObserver, AudioClientObserver {
    
    class UserInfo {
        let id: UInt
        let name: String
        let avatar: String?
        weak var assembly: FieldAssembly?
        var isMine: Bool {
            return id == AccountManager.shared.id
        }
        @Published var micOpen: Bool = false
        @Published var cameraOpen: Bool = false
        var onBufferSubject = PassthroughSubject<(pixelBuffer: CVPixelBuffer, rotation: Int), Never>()
        
        init(id: UInt, name: String, avatar: String?, assembly: FieldAssembly?) {
            self.id = id
            self.name = name
            self.avatar = avatar
            self.assembly = assembly
        }
        
    }
    
    var users: [UserInfo] = []
    
    var photosData: JSON = JSON()
    let onUserSubject = PassthroughSubject<(users: [UserInfo], joined: Bool), Never>()
    var mine: UserInfo!
    var faceTime: FaceTimeClient {
        return assembly.resolve()
    }
    var audioClient: AudioClient {
        return assembly.resolve()
    }
    var rtcClient: RTCClient {
        return assembly.resolve()
    }
    
//    @Published var cameraFront = true
    
    override func initialize() {
        assembly.usersManager()
            .onUserChanged
            .sink { [weak self] info in
                self?.userChanged(info.users, info.joind)
            }
            .store(in: &cancellableSet)
        userChanged(assembly.usersManager().users, true)
        mine = users.first(where: { AccountManager.shared.id == $0.id })
        rtcClient.login()
        
        mine.$cameraOpen
            .sink { [weak self] cameraOpen in
                guard let self = self else { return }
                if cameraOpen {
                    self.faceTime.addObserver(self)
                } else {
                    self.faceTime.removeObserver(self)
                }
            }
            .store(in: &cancellableSet)
        
        mine.$micOpen
            .sink { [weak self] micOpen in
                guard let self = self else { return }
                if micOpen {
                    self.audioClient.addObserver(self)
                } else {
                    self.audioClient.removeObserver(self)
                }
            }
            .store(in: &cancellableSet)
     
    }
    
    override func willUnmount() {
        faceTime.removeObserver(self)
        audioClient.removeObserver(self)
        rtcClient.logOut()
    }
    
    func add() {
        let uid = 10 + users.count
        var user = FieldUserModel(id: UInt(uid))
        let profile = Mediator.resolve(MeService.ProfileService.self)?.profile
        user.name = "\(uid)"
        user.avatar = profile?.avatar
        
        userChanged([FieldUserKit(userInfo: user, assembly: assembly)], true)
    }
    
    func remove() {
        let profile = Mediator.resolve(MeService.ProfileService.self)?.profile

        let u = users[Int.random(in: 0...(users.count - 1))]
        var user = FieldUserModel(id: u.id)
        user.name = "\(u)"
        user.avatar = profile?.avatar
        
        userChanged([FieldUserKit(userInfo: user, assembly: assembly)], false)
    }
    
    func userChanged(_ changeUsers: [FieldUserKit], _ joined: Bool) {
        var newUsers: [UserInfo] = []
        
        if joined {
            newUsers = changeUsers.map({ UserInfo(id: $0.id, name: $0.displayName, avatar: $0.info.avatar, assembly: self.assembly)})
            self.users.append(contentsOf: newUsers)
        } else {
            for user in changeUsers {
                if let newUser = self.users.removeFirst(where: { user.id == $0.id }) {
                    newUsers.append(newUser)
                }
            }
        }
        
        for user in newUsers {
            let fragmentValue = getFragemtFrom(user: user.id)
            if let micOpen = fragmentValue["mic"].bool {
                user.micOpen = micOpen
            }
            if let cameraOpen = fragmentValue["camera"].bool {
                user.cameraOpen = cameraOpen
            }
        }
        onUserSubject.send((users: newUsers, joined: joined))
    }
    
    override func updateUser(userId: String, full: JSON, change: JSON) {
        if let user = users.first(where: { $0.id == UInt(userId) }) {
            if let micOpen = change["mic"].bool {
                user.micOpen = micOpen
            }
            if let cameraOpen = change["camera"].bool {
                user.cameraOpen = cameraOpen
            }
        }
    }
    
    func changeMic(open: Bool) {
        syncMe(fragment: ["mic": open])
    }
    
    func changeCamera(open: Bool) {
        syncMe(fragment: ["camera": open])
    }
    
    override var height: CGFloat {
        FaceTimeLayoutEngine.containerSize.height + 60
    }
    
    func updateBuffer(pixelBuffer: CVPixelBuffer, rotation: Int) {
//        if !cameraFront {
            mine.onBufferSubject.send((pixelBuffer: pixelBuffer, rotation: rotation))
            rtcClient.sendVideo(pixelBuffer: pixelBuffer, rotation: rotation)
//        }
    }
    
    func updateFrontBuffer(pixelBuffer: CVPixelBuffer, rotation: Int) {
//        if cameraFront {
            mine.onBufferSubject.send((pixelBuffer: pixelBuffer, rotation: rotation))
            rtcClient.sendVideo(pixelBuffer: pixelBuffer, rotation: rotation)
//        }
    }
    
    func audioClientUpdateBuffer(_ pcmBuffer: AVAudioPCMBuffer) {
        rtcClient.sendAudio(data: pcmBuffer)
    }
    
//    func trcJoined(_ joined: Bool) {
//
////        let channel =
////        if joined {
////            self.remoterfaceInfo = channel.getRemoteUserByUID(uid: self.user.id)
////            self.remoterfaceInfo?.captureVideoFrame(onVideoFrameCall: { data, rotation in
////                print("pushVideoFrame === 2")
////
////                self.renderView.renderVideoFrame(pixelBuffer: data, rotation: rotation)
////            })
////        } else {
////            self.remoterfaceInfo = nil
////
////        }
//    }
}
