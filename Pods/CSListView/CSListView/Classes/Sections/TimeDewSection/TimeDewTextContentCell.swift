//
//  TimeDewTextContentController.swift
//  CSListView
//
//  Created by fuhao on 2023/6/16.
//
import Foundation
import IGListSwiftKit
import IGListKit





class TimeDewTextContentCell : UICollectionViewCell, ListBindable{
    let zoneView: TimeDewZoneView = {
        let view = TimeDewZoneView()
        view.fill()
        return view
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_lightGrey
        label.textAlignment = .natural
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        
        label.textColor = UIColor(red: 0.892, green: 0.892, blue: 0.892, alpha: 1)
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .cs_3D3A66_20
        
        contentView.addSubview(zoneView)
        contentView.addSubview(contentLabel)
        
        zoneView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(28)
            make.right.equalTo(-28)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }

    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? TimeDewTextContentCellModel else { return }
        contentLabel.text = viewModel.content
        if viewModel.isBottom {
            zoneView.bottom()
        }else{
            zoneView.fill()
        }
    }
    
    public static func forHeight(width: CGFloat, text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 14)
        let insets = UIEdgeInsets(top: 0, left: 28, bottom: 10, right: 28)
        let constrainedSize = CGSize(width: width - insets.left - insets.right, height: CGFloat.greatestFiniteMagnitude)
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        let bounds = text.boundingRect(with: constrainedSize, options: options, attributes: attributes, context: nil)
        return ceil(bounds.size.height) + insets.top + insets.bottom
    }
    
}

