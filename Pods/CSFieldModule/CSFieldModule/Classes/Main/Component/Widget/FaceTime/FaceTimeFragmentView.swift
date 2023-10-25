//
//  FaceTimeWidget.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/7.
//

import Foundation
import ComeSocialRTCService
import CSAccountManager
import CSNetwork

class FaceTimeFragmentView: WidgetFragmentView {
    
    var rtcClient: RTCClient {
        return assembly.resolve()
    }
    
    
    var layoutEngine: FaceTimeLayoutEngine = FaceTimeLayoutEngine()
    var faceViews: [FaceTimeView] = []
    let mediaControllerView = FaceTimeMediaControllerView()
    var facetimeFragment: FaceTimeFragment {
        return fragment as! FaceTimeFragment
    }
    
    override func initialize() {
        addSubview(mediaControllerView)
        mediaControllerView.micBtn.addTarget(self, action: #selector(micClick), for: .touchUpInside)
        mediaControllerView.cameraBtn.addTarget(self, action: #selector(cameraClick), for: .touchUpInside)
        mediaControllerView.switchCameraBtn.addTarget(self, action: #selector(switchCameraClick), for: .touchUpInside)
        facetimeFragment.onUserSubject
            .sink { [weak self] info in
                self?.userChanged(info.users, info.joined)
            }
            .store(in: &cancellableSet)
        userChanged(facetimeFragment.users, true)
        let mine = facetimeFragment.mine
        
        mine?
            .$cameraOpen
            .removeDuplicates()
            .weakAssign(to: \.cameraOpen, on: mediaControllerView)
            .store(in: &cancellableSet)
        mine?
            .$micOpen
            .removeDuplicates()
            .weakAssign(to: \.micOpen, on: mediaControllerView)
            .store(in: &cancellableSet)
        
//        assembly
//            .resolve(type: FaceTimeClient.self)
//            .onBufferSubject.sink(receiveValue: { [weak mine] (buffer, rotation) in
//                mine?.onBufferSubject.send((pixelBuffer: buffer, rotation: rotation))
//            })
//            .store(in: &cancellableSet)
//        assembly
//            .resolve(type: FaceTimeClient.self)
//            .onBufferSubject.sink(receiveValue: { [weak mine] (buffer, rotation) in
//                mine?.onBufferSubject.send((pixelBuffer: buffer, rotation: rotation))
//            })
//            .store(in: &cancellableSet)
    }
    
    @objc func micClick() {
//        facetimeFragment.add()
//
        let mic = facetimeFragment.mine?.micOpen ?? false
        facetimeFragment.changeMic(open: !mic)
    }
    
    @objc func cameraClick() {
//        facetimeFragment.remove()
        
        let camera = facetimeFragment.mine?.cameraOpen ?? false
        facetimeFragment.changeCamera(open: !camera)
    }
    
    @objc func switchCameraClick() {
//        facetimeFragment.cameraFront.toggle()
        assembly.resolve(type: FaceTimeClient.self).switchCamera()
    }
 
}

extension FaceTimeFragmentView {
    
    func userChanged(_ changeUsers: [FaceTimeFragment.UserInfo], _ joined: Bool) {
        if joined {
            addUsers(changeUsers)
        } else {
            removeUsers(changeUsers)
        }
        UIView.animate(withDuration: FaceTimeView.animateDuration) {
            self.mediaControllerView.frame = CGRect(origin: CGPoint(x: self.layoutEngine.area.midX - 81, y: self.layoutEngine.area.maxY + 10), size: CGSize(width: 162, height: 50))
        }
    }
    
    func addUsers(_ users: [FaceTimeFragment.UserInfo]) {
        let preCount = faceViews.count
        layoutEngine.change(face: faceViews.count + users.count)
        animationFaceViews()
        for (index, user) in users.enumerated() {
            let faceView = FaceTimeView(user: user)
            faceViews.append(faceView)
            addSubview(faceView)
            faceView.show(to: layoutEngine.getFaceFrame(index: preCount + index), style: layoutEngine.style)
        }
    }
    
    func removeUsers(_ users: [FaceTimeFragment.UserInfo]) {
        
        var newFaceViews: [FaceTimeView] = []
        for faceView in faceViews {
            if (users.contains(where: { $0.id == faceView.user.id })) {
                faceView.dismiss()
            } else {
                newFaceViews.append(faceView)
            }
        }
        faceViews = newFaceViews
        layoutEngine.change(face: faceViews.count)
        animationFaceViews()
    }
    
    func animationFaceViews() {
        for (index, faceView) in faceViews.enumerated() {
            faceView.move(to: layoutEngine.getFaceFrame(index: index), style: layoutEngine.style)
        }
    }
    
}

