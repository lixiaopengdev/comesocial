//
//  AvatarView.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/5/19.
//

import Foundation
import CSUtilities
import CSImageKit

public class AvatarView: UIView {
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .cs_cardColorA_10
        return imageView
    }()
    
    public var borderColor: UIColor = UIColor.cs_decoLightPurple {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    public var borderWidth: CGFloat = 3 {
        didSet {
            layer.borderWidth = borderWidth
            avatarImageView.frame = CGRect(x: borderWidth, y: borderWidth, width: frame.width - borderWidth * 2, height: frame.width - borderWidth * 2)
        }
    }
    
    convenience public init(uid: UInt) {
        self.init(frame: .zero)
    }
    
    convenience public init(url: String) {
        self.init(frame: .zero)
    }
    
   convenience public init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        addSubview(avatarImageView)
    }
    
    public func updateAvatar(_ url: String?) {
        avatarImageView.setAvatar(with: url)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.frame = CGRect(x: borderWidth, y: borderWidth, width: frame.width - borderWidth * 2, height: frame.width - borderWidth * 2)
        layerCornerRadius = frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
