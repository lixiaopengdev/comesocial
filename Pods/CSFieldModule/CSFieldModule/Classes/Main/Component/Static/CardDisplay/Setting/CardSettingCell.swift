//
//  CardSettingCell.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/16.
//

import UIKit
import CSUtilities

class CardSettingCell: UITableViewCell {

    enum DetailType {
        case swi(Bool)
        case selected(Bool)
        case more(String)
        
        var isSwi: Bool {
            if case .swi = self {
                return true
            }
            return false
        }
        var isSelected: Bool {
            if case .selected = self {
                return true
            }
            return false
        }
        var isMore: Bool {
            if case .more = self {
                return true
            }
            return false
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .name(.avenirNextRegular, size: 15)
        return label
    }()
    
    let switchBtn: CSSwitch = {
        let swi = CSSwitch()
        return swi
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: 0xebebf5, alpha: 0.6)
        label.font = .name(.avenirNextRegular, size: 15)
        return label
    }()
    
    let iconImageView = UIImageView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(hex: 0x2c2c2e, alpha: 0.7)
        selectionStyle = .none
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(switchBtn)

        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.right.equalTo(iconImageView.snp.left).offset(-1)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        iconImageView.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        switchBtn.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        nameLabel.text = "Time Interval"
    }
    
    func updateContent(index: Int) {
        if index % 3 == 0 {
            updateType(type: .swi(true))
        } else if index % 3 == 1 {
            updateType(type: .selected(true))
        } else {
            updateType(type: .more("5 Seconds"))
        }
    }
    
    private func updateType(type: DetailType) {
        
        subTitleLabel.isHidden = !type.isMore
        iconImageView.isHidden = type.isSwi
        switchBtn.isHidden = !type.isSwi
        switch type {
        case .swi(let value):
            switchBtn.isOn = value
        case .selected(let value):
            iconImageView.image = UIImage.bundleImage(named: "card_setting_selected")
            iconImageView.isHidden = !value
        case .more(let value):
            iconImageView.image = UIImage.bundleImage(named: "card_setting_more")
            subTitleLabel.text = value
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
