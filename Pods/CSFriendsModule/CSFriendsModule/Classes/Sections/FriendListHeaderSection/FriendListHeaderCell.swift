//
//  FriendListHeaderCell.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/6/14.
//

final class FriendListHeaderCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        let label = UILabel()
        label.textColor = .cs_pureWhite
        label.font = .boldLargeTitle
        label.text = "My Friends"
        let imageView = UIImageView(image:  UIImage.bundleImage(named: "friend_header_invite"))
        
        let actionLabel = UILabel()
        actionLabel.textColor = .cs_pureWhite
        actionLabel.font = .boldTitle1
        actionLabel.text = "Add Friends"
        
        contentView.addSubview(label)
        contentView.addSubview(imageView)
        imageView.addSubview(actionLabel)
        
        label.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalToSuperview()
            make.height.equalTo(48)
        }
        imageView.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(48)
            make.bottom.equalTo(-8)
        }
        
        actionLabel.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.centerY.equalToSuperview()
        }
       
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
