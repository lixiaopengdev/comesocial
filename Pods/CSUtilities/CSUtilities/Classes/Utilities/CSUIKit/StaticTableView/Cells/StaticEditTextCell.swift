//
//  StaticEditTextCell.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/5/9.
//

import UIKit

class StaticEditTextCell: UITableViewCell, UITextViewDelegate {
    
    weak var data: StaticEditTextCellData?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_softWhite
        label.font = .regularBody
        return label
    }()
    
    let textView: TextView = {
        let textV = TextView()
        textV.textColor = .cs_pureWhite
        textV.font = .regularSubheadline
        textV.placeholder = "Bio is empty."
        textV.backgroundColor = .cs_cardColorA_40
        textV.layerCornerRadius = 10
        textV.returnKeyType = .done
        return textV
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .cs_cardColorA_40
        view.layerCornerRadius = 14
        return view
    }()

    init(data: StaticEditTextCellData) {
        super.init(style: .default, reuseIdentifier: "")
        backgroundColor = .clear
        selectionStyle = .none
        
        self.data = data
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 14, bottom: 5, right: 14))
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(15)
        }
        
        containerView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.bottom.equalTo(-15)
            make.height.equalTo(120)
        }
        
        textView.delegate = self
      
    }
    
    func update() {
        guard let data = self.data else { return }
        titleLabel.text = data.title
        textView.text = data.content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if let data = data {
                data.endEditCallback?(data)
            }
            textView.endEditing(true)
            return false
        }
        return true
    }
}
