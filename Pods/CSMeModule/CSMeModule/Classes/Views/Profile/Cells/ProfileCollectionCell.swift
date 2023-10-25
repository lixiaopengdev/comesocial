////
////  File.swift
////  CSMeModule
////
////  Created by 于冬冬 on 2023/5/5.
////
//
//import Foundation
//import CSImageKit
//import CSUtilities
//import CSAccountManager
//
//class ProfileCollectionCell: UITableViewCell {
//    var item: CollectionModel?
////    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
////    var rightBtnClickCallback: Action2<ItemDisplay, IndexPath>?
//
//    let backgroundRect: UIView = {
//        let view = UIView()
//        view.backgroundColor = .cs_3D3A66_20
//        view.layerCornerRadius = 12
//        return view
//    }()
//    
//    private let avatarImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.backgroundColor = .cs_cardColorA_20
//        imageView.layerCornerRadius = 18
//        return imageView
//    }()
//    
//    let nameLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .cs_softWhite
//        label.font = .boldBody
//        return label
//    }()
//    
//    let timeLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .cs_lightGrey
//        label.font = .regularCaption1
//        return label
//    }()
//    
//    let contentLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .cs_softWhite
//        label.font = .regularSubheadline
//        label.numberOfLines = 0
//        return label
//    }()
//    
//    private let contetImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.backgroundColor = .cs_cardColorA_20
//        imageView.layerCornerRadius = 5
//        return imageView
//    }()
//    
//    private lazy var rightButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.titleLabel?.font = .boldSubheadline
//        button.setTitleColor(.cs_primaryPink, for: .normal)
//        button.setTitleColor(.cs_lightGrey, for: .disabled)
//        button.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
//        return button
//    }()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        backgroundColor = .clear
//        selectionStyle = .none
//        
//        addSubview(backgroundRect)
//        backgroundRect.addSubview(avatarImageView)
//        backgroundRect.addSubview(nameLabel)
//        backgroundRect.addSubview(timeLabel)
//        backgroundRect.addSubview(contentLabel)
//        backgroundRect.addSubview(rightButton)
//        backgroundRect.addSubview(contetImageView)
//        
//        backgroundRect.snp.makeConstraints { make in
//            make.edges.equalTo(UIEdgeInsets(top: 5, left: 18, bottom: 5, right: 18))
//        }
//        avatarImageView.snp.makeConstraints { make in
//            make.left.top.equalTo(14)
//            make.size.equalTo(36)
//        }
//        nameLabel.snp.makeConstraints { make in
//            make.left.equalTo(avatarImageView.snp.right).offset(10)
//            make.right.equalTo(-10)
//            make.top.equalTo(avatarImageView.snp.top)
//        }
//        
//        timeLabel.snp.makeConstraints { make in
//            make.left.equalTo(avatarImageView.snp.right).offset(10)
//            make.top.equalTo(nameLabel.snp.bottom)
//        }
//        contentLabel.snp.makeConstraints { make in
//            make.top.equalTo(avatarImageView.snp.bottom).offset(5)
//            make.left.equalTo(16)
//            make.right.equalTo(-16)
//        }
//        contetImageView.snp.makeConstraints { make in
//            make.left.equalTo(16)
//            make.top.equalTo(contentLabel.snp.bottom).offset(6)
//            make.height.equalTo(180)
//            make.width.equalTo(120)
//        }
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func update(_ item: CollectionModel) {
//        self.item = item
//        nameLabel.text = item.title
//        if let date = item.timeStamp {
//            timeLabel.text = date.string(withFormat: "HH:mm")
//        } else {
//            timeLabel.text = ""
//        }
//        avatarImageView.setAvatar(with: item.onwerThumb)
//        contentLabel.text = item.content.isEmpty ? " " : item.content
//        contetImageView.isHidden = item.pic == nil
//        contetImageView.setImage(with: item.pic)
//        
//    }
//    
//    @objc private func rightClick() {
////        if let item = item {
////            rightBtnClickCallback?(item, indexPath)
////        }
//    }
//    
//}