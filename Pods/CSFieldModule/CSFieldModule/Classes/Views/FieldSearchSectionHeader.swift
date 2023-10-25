//
//  FieldSearchSectionHeader.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/4/14.
//

//import Foundation
//import CSUtilities
//
//class FieldSearchSectionHeader: UIView {
//
//    var actionCallback: Action?
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .cs_softWhite2
//        label.font = .boldBody
//        return label
//    }()
//
//    lazy var actionBtn: UIButton = {
//        let button = UIButton(type: .custom)
//        button.titleLabel?.font = .regularSubheadline
//        button.setTitleColor(.cs_decoLightPurple, for: .normal)
//        return button
//    }()
//
//    init(title: String, actionName: String? = nil) {
//        super.init(frame: .zero)
//
//        titleLabel.text = title
//        actionBtn.setTitle(actionName, for: .normal)
//
//        addSubview(titleLabel)
//        addSubview(actionBtn)
//
//        titleLabel.snp.makeConstraints { make in
//            make.left.equalTo(18)
//            make.centerY.equalToSuperview()
//        }
//        actionBtn.snp.makeConstraints { make in
//            make.right.equalTo(-18)
//            make.centerY.equalToSuperview()
//        }
//        actionBtn.addTarget(self, action: #selector(actionClick), for: .touchUpInside)
//    }
//
//    @objc func actionClick() {
//        actionCallback?()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
