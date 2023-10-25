////
////  FriendItemCell.swift
////  CSFriendsModule
////
////  Created by 于冬冬 on 2023/5/11.
////
//
//
//import UIKit
//import SnapKit
//import CSImageKit
//import CSUtilities
//
//class FriendItemCell: UITableViewCell {
//    
//    var rightBtnClickCallback: Action2<ItemDisplay, IndexPath>?
//    var right1BtnClickCallback: Action2<ItemDisplay, IndexPath>?
//    
//    var item: FriendItemDisplay?
//    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
//    
//    private var nameConstraint: Constraint?
//    
//    private let nameLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .cs_pureWhite
//        label.font = .boldBody
//        return label
//    }()
//    
//    private let fieldLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .cs_softWhite
//        label.font = .regularFootnote
//        return label
//    }()
//    
//    private let avatarImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.backgroundColor = .cs_cardColorA_20
//        return imageView
//    }()
//    
//    private let relationIcon: UILabel = {
//        let label = UILabel()
//        label.font = .boldBody
//        return label
//    }()
//    
//    private let onlineView: UIView = {
//        let imageView = UIView()
//        return imageView
//    }()
//    
//    private lazy var rightButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.titleLabel?.font = .boldSubheadline
//        //        button.setTitleColor(.cs_primaryPink, for: .normal)
//        button.setTitleColor(.cs_lightGrey, for: .disabled)
//        button.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
//        return button
//    }()
//    
//    lazy var right1Button: UIButton = {
//        let button = UIButton(type: .system)
//        button.titleLabel?.font = .boldSubheadline
//        //        button.setTitleColor(.cs_primaryPink, for: .normal)
//        button.setTitleColor(.cs_lightGrey, for: .disabled)
//        button.addTarget(self, action: #selector(right1Click), for: .touchUpInside)
//        return button
//    }()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        backgroundColor = .clear
//        selectionStyle = .none
//        
//        avatarImageView.layerCornerRadius = 24
//        onlineView.backgroundColor = UIColor(hex: 0x5ef190)
//        onlineView.layerCornerRadius = 4
//        
//        let textContainer = UIView()
//        
//        contentView.addSubview(avatarImageView)
//        contentView.addSubview(relationIcon)
//        contentView.addSubview(textContainer)
//        textContainer.addSubview(nameLabel)
//        textContainer.addSubview(fieldLabel)
//        contentView.addSubview(onlineView)
//        contentView.addSubview(rightButton)
//        contentView.addSubview(right1Button)
//        
//        rightButton.snp.contentCompressionResistanceHorizontalPriority = 1000
//        rightButton.snp.contentHuggingHorizontalPriority = 1000
//        
//        right1Button.snp.contentCompressionResistanceHorizontalPriority = 999
//        right1Button.snp.contentHuggingHorizontalPriority = 999
//
//        avatarImageView.snp.makeConstraints { make in
//            make.size.equalTo(CGSize(width: 48, height: 48))
//            make.left.equalToSuperview().offset(18)
//            make.centerY.equalToSuperview()
//        }
//        onlineView.snp.makeConstraints { make in
//            make.bottom.equalTo(avatarImageView.snp.bottom).offset(-1)
//            make.right.equalTo(avatarImageView.snp.right).offset(-1)
//            make.size.equalTo(CGSize(width: 8, height: 8))
//        }
//        relationIcon.snp.makeConstraints { make in
//            make.left.equalTo(avatarImageView.snp.right).offset(12)
//            make.centerY.equalToSuperview()
//        }
//        textContainer.snp.makeConstraints { make in
//            nameConstraint = make.left.equalTo(avatarImageView.snp.right).offset(36).constraint
//            make.centerY.equalToSuperview()
//            make.right.equalTo(-15)
//        }
//        nameLabel.snp.makeConstraints { make in
//            make.left.top.equalToSuperview()
//            make.right.equalTo(rightButton.snp.left).offset(-10)
//        }
//        fieldLabel.snp.makeConstraints { make in
//            make.left.bottom.equalToSuperview()
//            make.top.equalTo(nameLabel.snp.bottom)
//            make.right.equalTo(nameLabel.snp.right)
//        }
//        rightButton.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.right.equalTo(-22)
//        }
//        right1Button.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.right.equalTo(rightButton.snp.left).offset(-16)
//        }
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func update(_ item: FriendItemDisplay) {
//        self.item = item
//        nameLabel.text = item.name
//        fieldLabel.text = item.subTitle
//        onlineView.isHidden = !item.online
//        let icon = item.relation?.icon
//        relationIcon.isHidden = icon == nil
//        relationIcon.text = icon
//        nameConstraint?.update(offset: icon == nil ? 12 : 36)
//        updateRight(button: rightButton, action: item.rightAction)
//        updateRight(button: right1Button, action: item.right1Action)
//        
//        if item.right1Action != .hide {
//            nameLabel.snp.remakeConstraints { make in
//                make.left.top.equalToSuperview()
//                make.right.equalTo(right1Button.snp.left).offset(-10)
//            }
//        } else if item.rightAction != .hide {
//            nameLabel.snp.remakeConstraints { make in
//                make.left.top.equalToSuperview()
//                make.right.equalTo(rightButton.snp.left).offset(-10)
//            }
//        } else {
//            nameLabel.snp.remakeConstraints { make in
//                make.left.top.equalToSuperview()
//                make.right.equalTo(-10)
//            }
//        }
//        if let image = UIImage.bundleImage(named: item.name) {
//            avatarImageView.image = image
//        } else {
//            avatarImageView.setAvatar(with: item.avatar)
//        }
//    }
//    
//    private func updateRight(button: UIButton, action: FriendItemRightStyle) {
//        switch action {
//        case .hide:
//            button.isHidden = true
//        case .enable(let text):
//            button.isHidden = false
//            button.isEnabled = true
//            button.setTitle(text, for: .normal)
//            button.setTitleColor(.cs_primaryPink, for: .normal)
//            
//        case .disable(let text):
//            button.isHidden = false
//            button.isEnabled = false
//            button.setTitle(text, for: .disabled)
//            button.setTitleColor(.cs_primaryPink, for: .normal)
//        case .enableDark(let text):
//            button.isHidden = false
//            button.isEnabled = true
//            button.setTitle(text, for: .normal)
//            button.setTitleColor(.cs_lightGrey, for: .normal)
//        }
//    }
//    
//    @objc private func rightClick() {
//        if let item = item {
//            rightBtnClickCallback?(item, indexPath)
//        }
//    }
//    @objc private func right1Click() {
//        if let item = item {
//            right1BtnClickCallback?(item, indexPath)
//        }
//    }
//}
//
//
