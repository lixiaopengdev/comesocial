//
//  ProfileRelationshipCell.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/5/16.
//

import Foundation

class ProfileUserAvatarCell: UICollectionViewCell {
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layerCornerRadius = 24
        return imageView
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(iconImageView)
        
        avatarImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        iconImageView.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.size.equalTo(14)
        }
        avatarImageView.setAvatar(with: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fsafe-img.xhscdn.com%2Fbw1%2F4d2a8885-131d-4530-835a-0ee12ae4201b%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fsafe-img.xhscdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1683105048&t=858875bf4e253fe95ef0534174afd65e")

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
