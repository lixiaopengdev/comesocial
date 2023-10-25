//
//  TimeDewReactionController.swift
//  CSListView
//
//  Created by fuhao on 2023/6/16.
//

import Foundation
import IGListSwiftKit
import IGListKit




protocol TimeDewReactionCellDelegate: AnyObject {
    func didTapReaction(cell: TimeDewReactionCell)
}


class TimeDewReactionCell : UICollectionViewCell, ListBindable{
    let zoneView: TimeDewZoneView = {
        let view = TimeDewZoneView()
        view.top()
        return view
    }()
    
    let backgroundRect: UIView = {
        let view = UIView()
        view.backgroundColor = .cs_cardColorA_40
        view.layerCornerRadius = 12
        return view
    }()
    
    let reactionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let reactionUsers: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(red: 0.892, green: 0.892, blue: 0.892, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    weak var delegate: TimeDewReactionCellDelegate? = nil
    var reactionLabel: String?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        contentView.addSubview(zoneView)
        contentView.addSubview(backgroundRect)
        backgroundRect.addSubview(reactionImageView)
        backgroundRect.addSubview(reactionUsers)
        
        backgroundRect.isUserInteractionEnabled = true
        backgroundRect.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onReactionClick)))
        
        zoneView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        backgroundRect.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(26)
            make.right.lessThanOrEqualToSuperview().offset(-26)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        reactionImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.width.equalTo(36)
            make.height.equalTo(24)
        }
        
        reactionUsers.snp.makeConstraints { make in
            make.left.equalTo(reactionImageView.snp.right).offset(4)
            make.right.equalToSuperview().offset(-8)
            make.top.greaterThanOrEqualToSuperview().offset(3)
            make.bottom.greaterThanOrEqualToSuperview().offset(-3)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc
    func onReactionClick() {
        delegate?.didTapReaction(cell: self)
    }

    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? TimeDewReactionCellModel else { return }
        guard let url = Bundle(for: TimeDewReactionCell.self).url(forResource: "CSListView", withExtension: "bundle") else { return }
        guard let localBundle = Bundle(url: url) else { return }
        
        reactionLabel = viewModel.reactionLabel
        reactionUsers.text = viewModel.reactionUsers.joined(separator: ",")
        reactionImageView.image = getReactionImageByIndex(localBundle: localBundle, label: viewModel.reactionLabel)
        
        if viewModel.isBottom {
            zoneView.bottom()
        }else{
            zoneView.fill()
        }
    }

    func getReactionImageByIndex(localBundle: Bundle, label: String) -> UIImage? {
        switch label {
        case "LOL":
            return UIImage(named: "reflection_lol", in: localBundle, compatibleWith: nil)
        case "OMG":
            return UIImage(named: "reflection_omg", in: localBundle, compatibleWith: nil)
        case "Cool":
            return UIImage(named: "reflection_cool", in: localBundle, compatibleWith: nil)
        case "Nooo":
            return UIImage(named: "reflection_nooo", in: localBundle, compatibleWith: nil)
        case "DAMN":
            return UIImage(named: "reflection_damn", in: localBundle, compatibleWith: nil)
        default:
            return nil
        }
    }
    
    public static func forHeight(width: CGFloat, users: [String]) -> CGFloat {
        let text = users.joined(separator: ",")
        let font = UIFont.systemFont(ofSize: 14)
        let insets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 8)
        let constrainedSize = CGSize(width: width - insets.left - insets.right - 28 - 36 - 26, height: CGFloat.greatestFiniteMagnitude)
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        let bounds = text.boundingRect(with: constrainedSize, options: options, attributes: attributes, context: nil)
        let caculateHeight = ceil(bounds.size.height) + insets.top + insets.bottom
        
        if caculateHeight > 30 {
            return caculateHeight + 12
        }
        
        return 30 + 12
    }
    
}
