//
//  SwitchCell.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/6/13.
//

import CSUtilities

protocol SwitchCellDelegate: AnyObject {
    func switchCellDidValueChanged(_ cell: SwitchCell)
}

final class SwitchCell: UICollectionViewCell {
    
    weak var delegate: SwitchCellDelegate?
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_pureWhite
        label.font = .boldTitle1
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_lightGrey
        label.font = .regularFootnote
        return label
    }()
    
    let switchBtn: CSSwitch = {
       let switchBtn = CSSwitch()
        return switchBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        switchBtn.addTarget(self, action: #selector(onSwitchValueChanged(_:)), for: .valueChanged)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(switchBtn)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.top.equalTo(16)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
        }
        
        switchBtn.snp.makeConstraints { make in
            make.right.equalTo(-18)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc private func onSwitchValueChanged(_ switch: UISwitch) {
        delegate?.switchCellDidValueChanged(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
