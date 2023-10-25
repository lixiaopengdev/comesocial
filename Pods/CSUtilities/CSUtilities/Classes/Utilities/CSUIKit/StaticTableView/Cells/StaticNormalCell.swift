//
//  StaticNormalCell.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/5/8.
//

import UIKit
import SnapKit

class StaticNormalCell: UITableViewCell {

    weak var data: StaticNormalCellData?
    
    lazy var rightIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.bundleImage(named: "arrow_right")
        return imageView
    }()
    lazy var rightSublabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_softWhite2
        label.font = .regularSubheadline
        return label
    }()
    
    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_pureWhite
        label.font = .boldBody
        return label
    }()
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_softWhite
        label.font = .regularBody
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_lightGrey
        label.font = .regularFootnote
        label.numberOfLines = 0
        return label
    }()
    
    lazy var switchBtn: CSSwitch = CSSwitch()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .cs_cardColorA_40
        view.layerCornerRadius = 14
        return view
    }()

    init(data: StaticNormalCellData) {
        super.init(style: .default, reuseIdentifier: "")
        self.data = data
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 14, bottom: 5, right: 14))
        }
        
        containerView.addSubview(rightLabel)
        containerView.addSubview(rightIcon)
        containerView.addSubview(rightSublabel)
        containerView.addSubview(switchBtn)
        containerView.addSubview(subTitleLabel)

        switchBtn.addTarget(self, action: #selector(switchValueChange), for: .valueChanged)
        update()
    }
    
    func update() {
        guard let data = self.data else { return }
        titleLabel.text = data.title

        titleLabel.snp.remakeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(15)
            make.bottom.equalTo(-15)
        }
        titleLabel.snp.contentCompressionResistanceHorizontalPriority = 1000
        
        rightLabel.isHidden = true
        rightIcon.isHidden = true
        switchBtn.isHidden = true
        rightSublabel.isHidden = true
        
        switch data.right {
        case .text(let rightString):
            rightLabel.isHidden = false
            rightLabel.text = rightString
            rightLabel.snp.remakeConstraints { make in
                make.right.equalTo(-16)
                make.left.equalTo(titleLabel.snp.right).offset(10)
                make.centerY.equalToSuperview()
            }
        case .detail(let text):
            rightIcon.isHidden = false
            rightSublabel.isHidden = false
            rightIcon.snp.remakeConstraints { make in
                make.right.equalTo(-16)
                make.centerY.equalToSuperview()
                make.size.equalTo(16)
            }
            if let text = text {
                rightSublabel.snp.remakeConstraints { make in
                    make.right.equalTo(rightIcon.snp.left).offset(-4)
                    make.centerY.equalToSuperview()
                }
                rightSublabel.text = text
            }
        case .switchBtn(let isOn, let action):
            switchBtn.isHidden = false
            switchBtn.snp.remakeConstraints { make in
                make.right.equalTo(-16)
                make.centerY.equalToSuperview()
            }
            switchBtn.isOn = isOn
        }
        

        
        if let subTitle = data.subtitle,
           !subTitle.isEmpty {
            subTitleLabel.text = subTitle
            titleLabel.snp.remakeConstraints { make in
                make.left.equalTo(16)
                make.top.equalTo(12)
            }
            subTitleLabel.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-80)
                make.top.equalTo(titleLabel.snp.bottom).offset(4)
                make.bottom.equalTo(-12)
            }
        }
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func switchValueChange() {
        if case .switchBtn(let _, let action) = self.data?.right {
            action?(switchBtn.isOn)
        }
    }
    
    deinit {
        print("StaticNormalCell deinit")
    }
    
}
