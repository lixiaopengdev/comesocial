//
//  AvatarCell.swift
//  CSListView
//
//  Created by 于冬冬 on 2023/6/13.
//

import CSCommon

final class ProfileHeaderInfoCell: UICollectionViewCell {
    
    let avatarImagView: AvatarView = {
        let imageView = AvatarView()
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_pureWhite
        label.font = .boldLargeTitle
        return label
    }()
    
    let onlineView: UIView = {
        let view = UIView()
        view.layerCornerRadius = 7
        view.backgroundColor = UIColor(hex: 0x5ef190)
        return view
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_softWhite
        label.font = .regularFootnote
        label.text = "@Ola_Nyman · 26 connections"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        contentView.addSubview(avatarImagView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(onlineView)

        avatarImagView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalToSuperview()
            make.size.equalTo(94)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.right.lessThanOrEqualTo(-36)
            make.top.equalTo(avatarImagView.snp.bottom).offset(17)
            make.height.equalTo(48)
        }
        onlineView.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.left.equalTo(nameLabel.snp.right).offset(8)
            make.size.equalTo(14)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom)
            make.height.equalTo(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
