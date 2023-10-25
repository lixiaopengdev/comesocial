//
//  UserCell.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/6/13.
//

import SnapKit
import CSUtilities

protocol UserCellDelegate: AnyObject {
    func userCellDidTapRightButton(_ cell: UserCell)
    func userCellDidTapleftButton(_ cell: UserCell)
}

final class UserCell: UICollectionViewCell {
    
    weak var delegate: UserCellDelegate?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_pureWhite
        label.font = .boldBody
        return label
    }()
    
    let fieldLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_softWhite
        label.font = .regularFootnote
        return label
    }()
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .cs_cardColorA_20
        return imageView
    }()
    
    let relationIcon: UILabel = {
        let label = UILabel()
        label.font = .boldBody
        return label
    }()
    
    let onlineView: UIView = {
        let imageView = UIView()
        return imageView
    }()
    
    lazy var rightButton: LoaderButton = {
        let button = LoaderButton(type: .system)
        button.titleLabel?.font = .boldSubheadline
        button.setTitleColor(.cs_lightGrey, for: .disabled)
        button.addTarget(self, action: #selector(onRightButton), for: .touchUpInside)
        return button
    }()
    
    lazy var leftButton: LoaderButton = {
        let button = LoaderButton(type: .system)
        button.titleLabel?.font = .boldSubheadline
        button.setTitleColor(.cs_lightGrey, for: .disabled)
        button.addTarget(self, action: #selector(onLeftButton), for: .touchUpInside)
        return button
    }()
    
    let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        avatarImageView.layerCornerRadius = 24
        onlineView.backgroundColor = UIColor(hex: 0x5ef190)
        onlineView.layerCornerRadius = 4
        
        let textContainer: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .leading
            stackView.distribution = .fill
            return stackView
        }()
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 22))
        }
        
        containerView.addArrangedSubview(avatarImageView)
        containerView.addSubview(onlineView)
        containerView.addArrangedSubview(relationIcon)
        containerView.addArrangedSubview(textContainer)
        textContainer.addArrangedSubview(nameLabel)
        textContainer.addArrangedSubview(fieldLabel)
        containerView.addArrangedSubview(leftButton)
        containerView.addArrangedSubview(rightButton)
        
        avatarImageView.snp.contentCompressionResistanceHorizontalPriority = 1000
        avatarImageView.snp.contentHuggingHorizontalPriority = 1000
        
        rightButton.snp.contentCompressionResistanceHorizontalPriority = 999
        rightButton.snp.contentHuggingHorizontalPriority = 999
        
        leftButton.snp.contentCompressionResistanceHorizontalPriority = 998
        leftButton.snp.contentHuggingHorizontalPriority = 998

//        textContainer.snp.contentCompressionResistanceHorizontalPriority = 997
//        textContainer.snp.contentHuggingHorizontalPriority = 997
        
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
        onlineView.snp.makeConstraints { make in
            make.bottom.equalTo(avatarImageView.snp.bottom).offset(-1)
            make.right.equalTo(avatarImageView.snp.right).offset(-1)
            make.size.equalTo(CGSize(width: 8, height: 8))
        }
        containerView.setCustomSpacing(12, after: avatarImageView)
  
        containerView.setCustomSpacing(8, after: relationIcon)

//        nameLabel.snp.makeConstraints { make in
//            make.left.top.right.equalToSuperview().priority(996)
//        }
//        fieldLabel.snp.makeConstraints { make in
//            make.left.right.bottom.equalToSuperview().priority(996)
//            make.top.equalTo(nameLabel.snp.bottom)
//        }
        containerView.setCustomSpacing(10, after: textContainer)

        leftButton.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(44).priority(998)
            make.width.greaterThanOrEqualTo(40).priority(998)
        }
        containerView.setCustomSpacing(16, after: leftButton)

        rightButton.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(44).priority(999)
            make.width.greaterThanOrEqualTo(40).priority(999)
        }
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onRightButton() {
        rightButton.isLoading = true
        rightButton.setTitle("", for: .normal)
        delegate?.userCellDidTapRightButton(self)
    }
    
    @objc private func onLeftButton() {
        leftButton.isLoading = true
        leftButton.setTitle("", for: .normal)
        delegate?.userCellDidTapleftButton(self)
    }
    
}
