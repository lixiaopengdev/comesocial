////
////  LiveStreamOpenView.swift
////  CSMeModule
////
////  Created by 于冬冬 on 2023/5/8.
////
//
//import UIKit
//import CSUtilities
//
//class ProfileSectionHeaderView: UITableViewHeaderFooterView {
//
//    var switchValueChangedCallback: Action1<Bool>?
//    
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .cs_pureWhite
//        label.font = .boldTitle1
//        return label
//    }()
//    
//    let subTitleLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .cs_lightGrey
//        label.font = .regularFootnote
//        return label
//    }()
//    
//    let switchBtn: CSSwitch = {
//       let switchBtn = CSSwitch()
//        return switchBtn
//    }()
//    
//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: reuseIdentifier)
//        
//        backgroundColor = UIColor.clear
//        switchBtn.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
//        addSubview(titleLabel)
//        addSubview(subTitleLabel)
//        addSubview(switchBtn)
//        
//        titleLabel.snp.makeConstraints { make in
//            make.left.equalTo(18)
//            make.right.equalTo(-18)
//            make.centerY.equalToSuperview()
//        }
//        subTitleLabel.snp.makeConstraints { make in
//            make.left.equalTo(18)
//            make.top.equalTo(titleLabel.snp.bottom).offset(1)
//        }
//        
//        switchBtn.snp.makeConstraints { make in
//            make.right.equalTo(-18)
//            make.centerY.equalToSuperview()
//        }
//    }
//    
//    func update(_ header: ProfileSectionHeaderDisplay) {
//        
//        titleLabel.text = header.title
//        subTitleLabel.text = header.subtitle
//
//        if (header.subtitle) != nil {
//            titleLabel.snp.remakeConstraints { make in
//                make.left.equalTo(18)
//                make.top.equalTo(16)
//            }
//        }
//        switchBtn.isHidden = header.open == nil
//        switchBtn.isOn = header.open ?? false
//    }
//    
//    @objc private func switchValueChanged() {
//        switchValueChangedCallback?(switchBtn.isOn)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
