//
//  FieldEntryUserAvatarView.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/5/17.
//

import Foundation

class FieldEntryUserAvatarView: UICollectionViewCell {
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layerCornerRadius = 13
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(avatarImageView)
        
        avatarImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        avatarImageView.setAvatar(with: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fsafe-img.xhscdn.com%2Fbw1%2F4d2a8885-131d-4530-835a-0ee12ae4201b%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fsafe-img.xhscdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1683105048&t=858875bf4e253fe95ef0534174afd65e")

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
