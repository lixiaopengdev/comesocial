//
//  FaceTimeView.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/11/22.
//

import UIKit
import MetalKit
import come_social_media_tools_ios
import CSUtilities
import Combine
import CSLogger
import CSNetwork
import SwiftyJSON
import ComeSocialRTCService
import CSImageKit
import CSFileKit
import CSCommon

class FaceTimeView: UIView {
    static let animateDuration: CGFloat = 0.5
    let user: FaceTimeFragment.UserInfo
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .cs_cardColorA_20
        return view
    }()
    let renderView =  SizeAdaptiveYUVRenderView()
    let avatarView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .cs_cardColorA_10
        view.contentMode = .scaleAspectFill
        return view
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_softWhite
        label.font = .regularFootnote
        label.textAlignment = .center
        return label
    }()
    let micIcon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var cancellableSet: Set<AnyCancellable> = []
    var remoteUser: RTCRemoteUser?
    
    init(user: FaceTimeFragment.UserInfo) {
        self.user = user
        super.init(frame: .zero)
        //        backgroundColor = .random()
        addSubview(containerView)
        addSubview(renderView)
        addSubview(avatarView)
        addSubview(micIcon)
        addSubview(nameLabel)
        
        renderView.startRender(user.id)
        
        user.$micOpen
            .removeDuplicates()
            .sink(receiveValue: { micOpen in
                self.micIcon.image = micOpen ? UIImage.bundleImage(named: "media_status_microphone_large_on") : UIImage.bundleImage(named: "media_status_microphone_large_off")
            })
            .store(in: &cancellableSet)
        user.$cameraOpen
            .removeDuplicates()
            .sink { [weak self] cameraOpen in
                self?.renderView.isHidden = !cameraOpen
                self?.avatarView.isHidden = cameraOpen
            }
            .store(in: &cancellableSet)
        
        nameLabel.text = user.name
        avatarView.setAvatar(with: user.avatar)
        
        if !user.isMine {
            let rtc = user.assembly?.resolve(type: RTCClient.self)
            rtc?.$isRTCJoined
                .removeDuplicates()
                .sink(receiveValue: { [weak self, weak rtc] joined in
                    if joined {
                        self?.remoteUser = rtc?.getRemoteUserByUID(user.id)
                        self?.remoteUser?.captureVideoFrame(onVideoFrameCall: { data, rotation in
                            self?.renderView.renderVideoFrame(pixelBuffer: data, rotation: rotation)
                        })
                    } else {
                        self?.remoteUser = nil
                    }
                })
                .store(in: &cancellableSet)
        } else {
            user.onBufferSubject
                .sink { [weak self] (buffer, rotation) in
                    self?.renderView.renderVideoFrame(pixelBuffer: buffer, rotation: rotation)
                }
                .store(in: &cancellableSet)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func show(to newFrame: CGRect, style: FaceTimeLayoutEngine.Style) {
        layoutSubviews(to: newFrame, style: style, duration: 0)
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: FaceTimeView.animateDuration) {
            self.transform = .identity
            self.alpha = 1
        }
    }
    
    func dismiss() {
        
        UIView.animate(withDuration: FaceTimeView.animateDuration) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    func move(to newFrame: CGRect, style: FaceTimeLayoutEngine.Style) {
        
        let oriFrame = avatarView.frame
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fromValue = oriFrame.width / 2
        animation.toValue = style.avatarSize.width / 2
        animation.duration =  FaceTimeView.animateDuration
        avatarView.layer.add(animation, forKey: "cornerRadiusAnimation")
        
        UIView.animate(withDuration: FaceTimeView.animateDuration) {
            self.layoutSubviews(to: newFrame, style: style, duration: 1)
        }
    }
    
    deinit {
        print("FaceTimeView deinit")
    }
    
    func layoutSubviews(to newFrame: CGRect, style: FaceTimeLayoutEngine.Style, duration: CGFloat) {
        
        
        frame = newFrame
        let containerFrame = CGRect(x: 0, y: 0, width: newFrame.width, height: newFrame.width)
        containerView.frame = containerFrame
        renderView.frame = containerFrame
        avatarView.frame = CGRect(origin: .zero, size: style.avatarSize)
        avatarView.center = containerView.center
        micIcon.frame = CGRect(x: containerFrame.maxX - style.iconRightBottom - style.iconSize.width,
                               y: containerFrame.maxX - style.iconRightBottom - style.iconSize.height,
                               width: style.iconSize.width,
                               height: style.iconSize.height)
        nameLabel.frame = CGRect(x: 10, y: containerView.frame.maxX + 6, width: containerView.frame.width - 20, height: newFrame.height - containerView.frame.maxX - 6)
        nameLabel.font = style.nameFont
        
        renderView.layerCornerRadius = style.radius
        containerView.layerCornerRadius = style.radius
        avatarView.layerCornerRadius = style.avatarSize.width / 2
    }
    
}

private extension FaceTimeLayoutEngine.Style {
    var avatarSize: CGSize {
        switch self {
        case .small:
            return CGSize(width: 56, height: 56)
        case .middle:
            return CGSize(width: 80, height: 80)
        case .large:
            return CGSize(width: 128, height: 128)
        }
    }
    
    var iconSize: CGSize {
        switch self {
        case .small:
            return CGSize(width: 20, height: 20)
        default:
            return CGSize(width: 24, height: 24)
        }
    }
    
    var iconRightBottom: CGFloat {
        switch self {
        case .small:
            return 8
        case .middle:
            return 10
        case .large:
            return 16
        }
    }
    
    var nameFont: UIFont {
        switch self {
        case .small:
            return .regularCaption1
        default:
            return .regularFootnote
        }
    }
    
    var radius: CGFloat {
        switch self {
        case .small:
            return 16
        case .middle:
            return 20
        case .large:
            return 24
        }
    }
}
