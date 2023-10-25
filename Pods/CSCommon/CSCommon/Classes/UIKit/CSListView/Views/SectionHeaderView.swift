////
////  FriendSectionHeaderView.swift
////  CSFriendsModule
////
////  Created by 于冬冬 on 2023/5/11.
////
//
//import UIKit
//import CSUtilities
//
//class SectionHeaderView: UITableViewHeaderFooterView {
//    var section: SectionDisplay?
//    var sectionLeftClickCallback: Action2<SectionDisplay, Int>?
//    var sectionRightClickCallback: Action2<SectionDisplay, Int>?
//
//    var index: Int = 0
//
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .cs_softWhite
//        label.font = .boldBody
//        label.isUserInteractionEnabled = true
//        return label
//    }()
//
//    private let arrowImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage.bundleImage(named: "friend_section_more")
//        imageView.isUserInteractionEnabled = true
//        return imageView
//    }()
//
//    private let rightLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .cs_decoLightPurple
//        label.font = .regularSubheadline
//        label.isUserInteractionEnabled = true
//        return label
//    }()
//
//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: reuseIdentifier)
//        backgroundView = UIView()
//
//        let leftActionView = UIView()
//        leftActionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sectionLeftClick)))
//        titleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sectionLeftClick)))
//        arrowImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sectionLeftClick)))
//        rightLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sectionRightClick)))
//
//        contentView.addSubview(leftActionView)
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(arrowImageView)
//        contentView.addSubview(rightLabel)
//
//        titleLabel.snp.makeConstraints { make in
//            make.left.equalTo(18)
//            make.centerY.equalToSuperview()
//        }
//
//        arrowImageView.snp.makeConstraints { make in
//            make.left.equalTo(titleLabel.snp.right).offset(7)
//            make.centerY.equalToSuperview()
//        }
//
//        leftActionView.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview()
//            make.left.equalTo(18)
//            make.right.greaterThanOrEqualTo(arrowImageView.snp.right)
//            make.width.greaterThanOrEqualTo(60)
//        }
//
//        rightLabel.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.right.equalTo(-18)
//        }
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func updateSection(_ section: SectionDisplay) {
//        self.section = section
//        titleLabel.text = section.leftTitle
//        if let rightAttributedTitle = section.rightAttributedTitle {
//            rightLabel.attributedText = rightAttributedTitle
//        } else {
//            rightLabel.text = section.rightTitle
//        }
//        arrowImageView.isHidden = section.fold == nil
//        if let fold = section.fold {
//            arrowImageView.transform = CGAffineTransform(rotationAngle: fold ? CGFloat.pi : 0)
//        }
//    }
//
//    @objc private func sectionLeftClick() {
//
//        if let section = section {
//            sectionLeftClickCallback?(section, index)
//        }
//    }
//
//    @objc private func sectionRightClick() {
//
//        if let section = section {
//            sectionRightClickCallback?(section, index)
//        }
//    }
//
//}
