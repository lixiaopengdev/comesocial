//
//  TimeDewEventCell.swift
//  CSListView
//
//  Created by fuhao on 2023/6/19.
//

import Foundation
import IGListSwiftKit
import IGListKit

protocol TimeDewEventCellDelegate: AnyObject {
    func didEvent(cell: TimeDewEventCell)
}



class TimeDewEventCell : UICollectionViewCell, ListBindable{
    let zoneView: TimeDewZoneView = {
        let view = TimeDewZoneView()
        view.both()
        return view
    }()
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .cs_cardColorA_20
        imageView.layerCornerRadius = 18
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_softWhite
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    
    let eventButton: UIButton = {
        let button = UIButton()
        button.setTitle("Join", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.layer.backgroundColor = UIColor(red: 0.494, green: 0.416, blue: 0.702, alpha: 1).cgColor
        button.layer.cornerRadius = 6
        return button
    }()
    
    weak var delegate: TimeDewEventCellDelegate? = nil
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        contentView.addSubview(zoneView)
        zoneView.addSubview(avatarImageView)
        zoneView.addSubview(nameLabel)
        zoneView.addSubview(eventButton)
        
        eventButton.addTarget(self, action: #selector(onButtonClick), for: .touchUpInside)
        
        
        zoneView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.centerY.equalToSuperview()
            make.size.equalTo(36)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(10)
            make.right.equalTo(-101)
            make.centerY.equalTo(avatarImageView.snp.centerY)
        }
        
        
        eventButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-14)
            make.width.equalTo(61)
            make.height.equalTo(32)
        }
    }
    
    @objc
    func onButtonClick() {
        delegate?.didEvent(cell: self)
    }
    

    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? TimeDewViewModel else { return }
        avatarImageView.setImage(with: viewModel.icon)
        nameLabel.text = viewModel.content
    }
    
    
    public static func forHeight(width: CGFloat, avatarImageCount: Int, content: String) -> CGFloat {
        let avatarImageWidth:CGFloat = 36
        let font = UIFont.systemFont(ofSize: 16)
        let insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 103)
        let constrainedSize = CGSize(width: width - insets.left - insets.right - avatarImageWidth - 26, height: CGFloat.greatestFiniteMagnitude)
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        let bounds = content.boundingRect(with: constrainedSize, options: options, attributes: attributes, context: nil)
        let cellHeight = ceil(bounds.size.height) + insets.top + insets.bottom
        if cellHeight > 60 {
            return cellHeight + 10
        }
        return 60 + 10
    }
    
}

