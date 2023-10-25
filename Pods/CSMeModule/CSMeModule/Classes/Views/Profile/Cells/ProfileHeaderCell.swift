////
////  MeHeaderView.swift
////  CSMeModule
////
////  Created by 于冬冬 on 2023/5/8.
////
//
//import UIKit
//import CSUtilities
//import CSCommon
//
//class ProfileHeaderCell: UITableViewCell {
//    private static let bioFont = UIFont.regularSubheadline
//    var clickHeadButtonCallback: Action?
//
//    private let avatarImagView: AvatarView = {
//        let imageView = AvatarView()
//        return imageView
//    }()
//    
//    private let nameLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .cs_pureWhite
//        label.font = .boldLargeTitle
//        label.text = "Ola Nyman"
//        return label
//    }()
//    
//    private let onlineView: UIView = {
//        let view = UIView()
//        view.layerCornerRadius = 7
//        view.backgroundColor = UIColor(hex: 0x5ef190)
//        return view
//    }()
//    
//    private let subTitleLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .cs_softWhite
//        label.font = .regularFootnote
//        label.text = "@Ola_Nyman · 26 connections"
//        return label
//    }()
//    
//    private let bioLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .cs_pureWhite
//        label.font = ProfileHeaderCell.bioFont
//        label.numberOfLines = 0
//        return label
//    }()
//    
//    private let labelsView: LabelsView = {
//        let view = LabelsView()
//        return view
//    }()
//    
//    private lazy var fieldBtn: UIButton = {
//        let button = UIButton(type: .custom)
//        button.setBackgroundImage(UIImage.bundleImage(named: "gradient_button_rect_longer"), for: .normal)
//        button.setBackgroundImage(UIImage(color: .cs_3D3A66_40, size: CGSize(width: 1, height: 1)), for: .disabled)
//        button.setImage(UIImage.bundleImage(named: "button_icon_join"), for: .normal)
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
//        button.setTitleColor(.cs_softWhite2, for: .normal)
//        button.layerCornerRadius = 12
//        button.titleLabel?.font = .boldBody
//        button.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
//        return button
//    }()
//    
//    static func cellHeight(user: ProfileUserData) -> CGFloat {
//        let bioH: CGFloat = (user.bio?.calculateHeight(width: Device.UI.screenWidth - 36, font: bioFont)).map({ $0 + 18 }).unwrapped(or: 0)
//        
//        let labelsH: CGFloat = user.labels.isEmpty ? 0 : 12 + 22
//        let buttonH: CGFloat = user.action == nil ? 0 : 36 + 50
//        return 94 + 17 + 48 + 16 + bioH + labelsH + buttonH
//    }
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = UIColor.clear
//        selectionStyle = .none
//        
//        contentView.addSubview(avatarImagView)
//        contentView.addSubview(nameLabel)
//        contentView.addSubview(subTitleLabel)
//        contentView.addSubview(bioLabel)
//        contentView.addSubview(labelsView)
//        contentView.addSubview(fieldBtn)
//        contentView.addSubview(onlineView)
//        
//        avatarImagView.snp.makeConstraints { make in
//            make.left.equalTo(15)
//            make.top.equalToSuperview()
//            make.size.equalTo(94)
//        }
//        nameLabel.snp.makeConstraints { make in
//            make.left.equalTo(18)
//            make.right.lessThanOrEqualTo(-18)
//            make.top.equalTo(avatarImagView.snp.bottom).offset(17)
//            make.height.equalTo(48)
//        }
//        onlineView.snp.makeConstraints { make in
//            make.centerY.equalTo(nameLabel.snp.centerY)
//            make.left.equalTo(nameLabel.snp.right).offset(8)
//            make.size.equalTo(14)
//        }
//        subTitleLabel.snp.makeConstraints { make in
//            make.left.equalTo(nameLabel.snp.left)
//            make.top.equalTo(nameLabel.snp.bottom)
//            make.height.equalTo(16)
//        }
//        bioLabel.snp.makeConstraints { make in
//            make.left.equalTo(nameLabel.snp.left)
//            make.right.equalTo(-18)
//            make.top.equalTo(subTitleLabel.snp.bottom).offset(18)
//        }
//        labelsView.snp.makeConstraints { make in
//            make.left.equalTo(nameLabel.snp.left)
////            make.top.equalTo(bioLabel.snp.bottom).offset(12)
//            make.height.equalTo(22)
//            make.bottom.equalTo(-50 - 36)
//        }
//        fieldBtn.snp.makeConstraints { make in
//            make.left.equalTo(18)
//            make.right.equalTo(-18)
//            make.height.equalTo(50)
////            make.top.equalTo(labelsView.snp.bottom).offset(36)
//            make.bottom.equalToSuperview()
//        }
//        
//    }
//    
//    func update(user: ProfileUserData) {
//        nameLabel.text = user.name
//        onlineView.isHidden = !user.online
//        subTitleLabel.text = user.subName
//        bioLabel.text = user.bio
//        avatarImagView.updateAvatar(user.avatar)
//        fieldBtn.isHidden = user.action == nil
//        if let action = user.action {
//            switch action {
//            case .disable(let text, let image):
//                fieldBtn.isEnabled = false
//                fieldBtn.setTitle(text, for: .disabled)
//                fieldBtn.setImage(image, for: .disabled)
//            case .enable(let text, let image):
//                fieldBtn.isEnabled = true
//                fieldBtn.setTitle(text, for: .normal)
//                fieldBtn.setImage(image, for: .normal)
//            }
//        }
//        labelsView.isHidden = user.labels.isEmpty
//        if !user.labels.isEmpty {
//            labelsView.update(labels: user.labels)
//            labelsView.snp.updateConstraints { make in
//                make.bottom.equalTo(user.action == nil ? 0 : -50 - 36)
//            }
//        }
//
//    }
//    
//    @objc func closeBtnClick() {
//        self.clickHeadButtonCallback?()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
