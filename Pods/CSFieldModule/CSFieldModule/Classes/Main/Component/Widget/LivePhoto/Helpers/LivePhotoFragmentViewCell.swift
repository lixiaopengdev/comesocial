//
//  LivePhotoFragmentViewCell.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/5/26.
//

import UIKit
import CSCommon
import CSAccountManager
import come_social_media_tools_ios
import Combine

class LivePhotoFragmentViewCell: UICollectionViewCell {
    
    var faceTimeCancellable = Set<AnyCancellable>()
    weak var fragment: LivePhotoFragment?
    var faceTimeClient: FaceTimeClient? {
        return fragment?.assembly.resolve(type: FaceTimeClient.self)
    }
    var lastBuffer: CVPixelBuffer?
    var lastFrontBuffer: CVPixelBuffer?
    var cancellable = Set<AnyCancellable>()
    var isFront = true
    var isBack: Bool {
        return !isFront
    }
    
    let backPhotoView: UIImageView = {
        let imageView = UIImageView()
        imageView.layerCornerRadius = 14
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .cs_cardColorA_10
        return imageView
    }()
    
    let renderView: SizeAdaptiveYUVRenderView = {
        let renderView = SizeAdaptiveYUVRenderView()
        renderView.backgroundColor = .cs_cardColorA_10
        renderView.layerCornerRadius = 20
        renderView.frame = CGRect(x: 0, y: 0, width: 334, height: 334)
        return renderView
    }()
    
    
    let forePhotoView: UIImageView = {
        let imageView = UIImageView()
        imageView.layerCornerRadius = 20
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .cs_cardColorA_10
        return imageView
    }()
    
    let avatarImageView: AvatarView = {
        let imageView = AvatarView()
        imageView.borderWidth = 2
        return imageView
    }()
    
    let emptyavatarImageView: AvatarView = {
        let imageView = AvatarView()
        imageView.borderWidth = 0
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_softWhite
        label.font = .boldBody
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_softWhite
        label.font = .regularFootnote
        return label
    }()
    
    let browserContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_softWhite
        label.font = .boldHeadline
        label.text = "Add New"
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_softWhite
        label.font = .regularFootnote
        label.text = "Take new picture and upload it!"
        return label
    }()
    
    lazy var editButtton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.bundleImage(named: "field_inside_red_edit"), for: .normal)
        button.addTarget(self, action: #selector(showEdit), for: .touchUpInside)
        return button
    }()
    
    lazy var closeEditButtton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.bundleImage(named: "field_inside_dark_close"), for: .normal)
        button.addTarget(self, action: #selector(closeEdit), for: .touchUpInside)
        return button
    }()
    
    let editContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    let cameraActionView = CameraView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(browserContainer)
        contentView.addSubview(editContainer)
        
        browserContainer.addSubview(avatarImageView)
        browserContainer.addSubview(nameLabel)
        browserContainer.addSubview(timeLabel)
        browserContainer.addSubview(editButtton)
        browserContainer.addSubview(backPhotoView)
        backPhotoView.addSubview(forePhotoView)
        backPhotoView.addSubview(emptyavatarImageView)
        
        editContainer.addSubview(renderView)
        editContainer.addSubview(titleLabel)
        editContainer.addSubview(subtitleLabel)
        editContainer.addSubview(closeEditButtton)
        editContainer.addSubview(cameraActionView)
        
        editContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        browserContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backPhotoView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 74, left: 14, bottom: 0, right: 14))
        }
        forePhotoView.snp.makeConstraints { make in
            make.left.top.equalTo(14)
            make.size.equalTo(80)
        }
        emptyavatarImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(128)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.top.equalTo(14)
            make.size.equalTo(44)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(12)
            make.top.equalTo(16)
            make.right.equalTo(-15)
        }
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(12)
            make.top.equalTo(nameLabel.snp.bottom).offset(1)
            make.right.equalTo(-15)
        }
        editButtton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.top.equalTo(16)
            make.right.equalTo(-16)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(18)
            make.centerX.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
        closeEditButtton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.top.equalTo(16)
            make.right.equalTo(-16)
        }
        cameraActionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
        renderView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 74, left: 14, bottom: 0, right: 14))
        }
        
        editContainer.alpha = 0
        cameraActionView.takePhotoButtton.addTarget(self, action: #selector(takePhotoClick), for: .touchUpInside)
        cameraActionView.changeCameraButtton.addTarget(self, action: #selector(changeCameraClick), for: .touchUpInside)
        cameraActionView.closeButtton.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        cameraActionView.uploadButtton.addTarget(self, action: #selector(uploadClick), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func takePhotoClick() {
        cameraActionView.show(style: .upload)
    }
    
    @objc func changeCameraClick() {
        isFront.toggle()
    }
    
    @objc func closeClick() {
        cameraActionView.show(style: .photo)
    }
    
    @objc func uploadClick() {
        if let buffer = self.lastBuffer,
           let frontBuffer = self.lastFrontBuffer {
            Publishers.Zip(Utlis.saveBufferToServe(pixelBuffer: buffer, orientation: .right), Utlis.saveBufferToServe(pixelBuffer: frontBuffer, orientation: .left))
                .sink(success: { [weak self] urls in
                    self?.fragment?.syncPhoto(back: urls.0, fore: urls.1)
                }, failure: { error in
                    print(error)
                })
                .store(in: &cancellable)
        }
        cameraActionView.show(style: .photo)
        closeEdit()
    }
    
    @objc func showEdit() {
        UIView.animate(withDuration: 0.25) {
            self.browserContainer.alpha = 0
            self.editContainer.alpha = 1
        }
//        if !((faceTimeClient?.isOpen).unwrapped(or: false)) {
//            faceTimeClient?.start()
//        }
        renderView.startRender(AccountManager.shared.id)
//        faceTimeClient?.onBufferSubject
//            .sink(receiveValue: { [weak self] (buffer, rotation) in
//                if self?.cameraActionView.style == .photo {
//                    self?.lastBuffer = buffer
//                    if self?.isBack == true {
//                        self?.renderView.renderVideoFrame(pixelBuffer: buffer, rotation: rotation)
//                    }
//                }
//            })
//            .store(in: &faceTimeCancellable)
//
//        faceTimeClient?.onFrontBufferSubject
//            .sink(receiveValue: { [weak self] (buffer, rotation) in
//                if self?.cameraActionView.style == .photo {
//                    self?.lastFrontBuffer = buffer
//                    if self?.isFront == true {
//                        self?.renderView.renderVideoFrame(pixelBuffer: buffer, rotation: rotation)
//                    }
//                }
//            })
//            .store(in: &faceTimeCancellable)
    }
    
    @objc func closeEdit() {
        UIView.animate(withDuration: 0.25) {
            self.browserContainer.alpha = 1
            self.editContainer.alpha = 0
        }
        renderView.stopRender()
//        if ((faceTimeClient?.isOpen).unwrapped(or: false)) {
//            faceTimeClient?.stop()
//        }
        faceTimeCancellable.removeAll()
    }
    
    func update(photo: LivePhotoFragment.PhotoInfo) {
        let isMine = photo.id == AccountManager.shared.id
        nameLabel.text = (isMine ? "My" : photo.name) + " Photo Streaming"
        if let time = photo.time {
            timeLabel.text = "Last Update : " + Date(timeIntervalSince1970: time).stringAgo()
        } else {
            timeLabel.text = ""
        }
        avatarImageView.updateAvatar(photo.avatar)
        emptyavatarImageView.updateAvatar(photo.avatar)
        emptyavatarImageView.isHidden = photo.back != nil
        forePhotoView.isHidden = photo.fore == nil
        forePhotoView.setImage(with: photo.fore)
        backPhotoView.setImage(with: photo.back)
        editButtton.isHidden = !isMine
    }
    
}

extension LivePhotoFragmentViewCell {
    
    class CameraView: UIView {
        
        enum Style {
            case photo
            case upload
        }
        var style = Style.photo
        
        lazy var changeCameraButtton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage.bundleImage(named: "field_inside_change_camera"), for: .normal)
            return button
        }()
        
        lazy var takePhotoButtton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage.bundleImage(named: "field_inside_take_photo"), for: .normal)
            return button
        }()
        
        lazy var closeButtton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage.bundleImage(named: "field_inside_close"), for: .normal)
            return button
        }()
        
        lazy var uploadButtton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage.bundleImage(named: "field_inside_done"), for: .normal)
            return button
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(changeCameraButtton)
            addSubview(takePhotoButtton)
            addSubview(closeButtton)
            addSubview(uploadButtton)
            
            takePhotoButtton.snp.makeConstraints { make in
                make.bottom.equalTo(-21)
                make.centerX.equalToSuperview()
                make.size.equalTo(66)
            }
            
            changeCameraButtton.snp.makeConstraints { make in
                make.right.equalTo(takePhotoButtton.snp.left).offset(-30)
                make.centerY.equalTo(takePhotoButtton.snp.centerY)
                make.size.equalTo(48)
            }
            
            closeButtton.snp.makeConstraints { make in
                make.bottom.equalTo(-20)
                make.right.equalTo(self.snp.centerX).offset(-15)
                make.size.equalTo(60)
            }
            uploadButtton.snp.makeConstraints { make in
                make.bottom.equalTo(-20)
                make.left.equalTo(self.snp.centerX).offset(15)
                make.size.equalTo(60)
            }
            show(style: .photo)
        }
        
        func show(style: Style) {
            self.style = style
            UIView.animate(withDuration: 0.25) {
                self.changeCameraButtton.alpha = (style == .photo) ? 1 : 0
                self.takePhotoButtton.alpha = (style == .photo) ? 1 : 0
                self.closeButtton.alpha = (style == .photo) ? 0 : 1
                self.uploadButtton.alpha = (style == .photo) ? 0 : 1
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}

