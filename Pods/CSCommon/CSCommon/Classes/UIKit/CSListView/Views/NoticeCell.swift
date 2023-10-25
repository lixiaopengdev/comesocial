////
////  NoticeCell.swift
////  CSCommon
////
////  Created by 于冬冬 on 2023/6/7.
////
//
//import Foundation
//
//import Foundation
//import CSUtilities
//
//class NoticeCell: UITableViewCell {
//    
//    var item: NoticeItemDisplay?
//    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
//    var rightBtnClickCallback: Action2<ItemDisplay, IndexPath>?
//
//    let backgroundRect: UIView = {
//        let view = UIView()
//        view.backgroundColor = .cs_3D3A66_40
//        view.layerCornerRadius = 10
//        return view
//    }()
//    
//    let contentLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .cs_pureWhite
//        label.font = .regularSubheadline
//        label.textAlignment = .left
//        label.numberOfLines = 0
//        return label
//    }()
//
//    let iconImageView: AvatarView = AvatarView()
//    
//    lazy var viewBtn: UIButton = {
//        let button = UIButton(type: .custom)
//        button.setBackgroundColor(color: UIColor.cs_decoMidPurple, forState: .normal)
//        button.setTitleColor(.cs_pureWhite, for: .normal)
//        button.titleLabel?.font = .regularSubheadline
//        button.setTitle("View", for: .normal)
//        button.layerCornerRadius = 6
//        button.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
//        return button
//    }()
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        backgroundColor = .clear
//        selectionStyle = .none
//        iconImageView.borderWidth = 0
//        
//        contentView.addSubview(backgroundRect)
//        
//        backgroundRect.addSubview(contentLabel)
//        backgroundRect.addSubview(iconImageView)
//        backgroundRect.addSubview(viewBtn)
//        
//        backgroundRect.snp.makeConstraints { make in
//            make.edges.equalTo(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
//        }
//        iconImageView.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.left.equalTo(14)
//            make.size.equalTo(36)
//        }
//        contentLabel.snp.makeConstraints { make in
//            make.left.equalTo(iconImageView.snp.right).offset(10)
//            make.right.equalTo(-95)
//            make.top.bottom.equalToSuperview()
//        }
//        viewBtn.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.right.equalTo(-14)
//            make.size.equalTo(CGSize(width: 61, height: 32))
//        }
//
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func update(_ item: NoticeItemDisplay) {
//        self.item = item
//        contentLabel.text = item.content
//        iconImageView.updateAvatar(item.avatar.first)
//    }
//    
//    @objc private func rightClick() {
//        if let item = item {
//            rightBtnClickCallback?(item, indexPath)
//        }
//    }
//}
