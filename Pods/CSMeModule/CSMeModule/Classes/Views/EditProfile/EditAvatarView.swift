//
//  EditAvatarView.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/5/9.
//

import UIKit
import CSCommon

class EditAvatarView: UIView {

    var avatarTappedHandler:(() -> Void)?
    
    let avatarImagView: AvatarView = {
        let imageView = AvatarView()
        return imageView
    }()
    
    let editIconImagView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.bundleImage(named: "corner_mask_edit")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(avatarImagView)
        addSubview(editIconImagView)
        
        avatarImagView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(94)
        }
        editIconImagView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.right.equalTo(avatarImagView.snp.right).offset(4)
            make.bottom.equalTo(avatarImagView.snp.bottom).offset(4)
        }
        
        avatarImagView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarTapped)))
        
    }
    
    @objc func avatarTapped() {
        avatarTappedHandler?()
    }
    
    func update(avatar: String?) {
        avatarImagView.updateAvatar(avatar)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
