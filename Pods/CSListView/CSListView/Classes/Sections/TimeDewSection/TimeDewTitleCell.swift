//
//  TimeDewTitleInfoController.swift
//  CSListView
//
//  Created by fuhao on 2023/6/16.
//

import Foundation
import IGListSwiftKit
import IGListKit


protocol TimeDewTitleCellDelegate: AnyObject {
    func didTapAvatarImage(cell: TimeDewTitleCell)
}



class TimeDewTitleCell : UICollectionViewCell, ListBindable{
    let zoneView: TimeDewZoneView = {
        let view = TimeDewZoneView()
        view.top()
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
        label.font = .boldBody
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_lightGrey
        label.font = .regularCaption1
        return label
    }()
    
    let tipsIcon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    weak var delegate: TimeDewTitleCellDelegate? = nil
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        contentView.addSubview(zoneView)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(tipsIcon)
        
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onImageClick)))
        
        
        zoneView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.left.equalTo(26)
            make.top.equalTo(13)
            make.size.equalTo(36)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(10)
            make.right.equalTo(-50)
            make.top.equalTo(avatarImageView.snp.top)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(10)
            make.top.equalTo(nameLabel.snp.bottom)
        }
        
        tipsIcon.snp.makeConstraints { make in
            make.lastBaseline.equalTo(nameLabel)
            make.right.equalTo(-30)
            make.width.equalTo(9)
            make.height.equalTo(3)
        }
    }
    
    @objc
    func onImageClick() {
        delegate?.didTapAvatarImage(cell: self)
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 30)
    }
    

    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? TimeDewTitleCellModel else { return }
        
        avatarImageView.setImage(with: viewModel.icon)
        nameLabel.text = viewModel.title
        timeLabel.text = String(viewModel.timeStamp)
    }
    
    
    
}


