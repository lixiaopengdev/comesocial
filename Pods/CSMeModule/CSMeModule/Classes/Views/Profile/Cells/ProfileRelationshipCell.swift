////
////  ProfileRelationshipCell.swift
////  CSMeModule
////
////  Created by 于冬冬 on 2023/5/16.
////
//
//import Foundation
//import CSImageKit
//import CSUtilities
//
//class ProfileRelationshipCell: UITableViewCell {
//
//    let noneItemView = ProfileRelationItemView()
//    let friendsItemView = ProfileRelationItemView()
//    let closeFriendItemView = ProfileRelationItemView()
//
//    var clickItemCallback: Action1<ProfileRelationDisplayType>?
//
//    let containerView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.alignment = .fill
//        stackView.distribution = .fillProportionally
//        stackView.spacing = 12
//        return stackView
//    }()
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = UIColor.clear
//        selectionStyle = .none
//        
//        contentView.addSubview(containerView)
//        
//        containerView.addArrangedSubview(noneItemView)
//        containerView.addArrangedSubview(friendsItemView)
//        containerView.addArrangedSubview(closeFriendItemView)
//        
//        noneItemView.snp.makeConstraints { make in
//            make.width.equalTo(80)
//        }
//        friendsItemView.snp.makeConstraints { make in
//            make.width.equalTo(125)
//        }
//        closeFriendItemView.snp.makeConstraints { make in
//            make.width.equalTo(125)
//        }
//        containerView.snp.makeConstraints { make in
//            make.left.equalTo(18)
//            make.right.equalTo(-18)
//            make.top.bottom.equalToSuperview()
//        }
//        
//        noneItemView.update(ProfileRelationDisplayType.none, active: false)
//        friendsItemView.update(ProfileRelationDisplayType.friends(des: "23 connections"), active: false)
//        closeFriendItemView.update(ProfileRelationDisplayType.closeFriend(des: "10 connections"), active: true)
//        noneItemView.clickCallback = {[weak self] itemType in
//            self?.clickItemCallback?(itemType)
//        }
//        friendsItemView.clickCallback = {[weak self] itemType in
//            self?.clickItemCallback?(itemType)
//        }
//        closeFriendItemView.clickCallback = {[weak self] itemType in
//            self?.clickItemCallback?(itemType)
//        }
//
//    }
//    
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
