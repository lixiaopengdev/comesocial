//
//  MoreViewController.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/4/7.
//

import CSBaseView
import CSUtilities
//import CSRouter


class MoreViewController: BaseViewController {
    
    typealias MoreSection = [MoreItem]
    
    enum MoreItem {
        case share
        case info
        case dew
        case hide
        case report
        
        var image: UIImage? {
            switch self {
            case .share:
                return UIImage.bundleImage(named: "more_share")
            case .info:
                return UIImage.bundleImage(named: "more_field_info")
            case .dew:
                return UIImage.bundleImage(named: "more_field_dew")
            case .hide:
                return UIImage.bundleImage(named: "more_hide")
            case .report:
                return UIImage.bundleImage(named: "more_report")
            }
        }
        
        var title: String {
            switch self {
            case .share:
                return "Share"
            case .info:
                return "Field Info"
            case .dew:
                return "Field's Dew"
            case .hide:
                return "Hide"
            case .report:
                return "Report"
            }
        }
        var color: UIColor {
            if self == .report {
                return .cs_warningRed
            }
            return .cs_softWhite2
        }
        
        var height: CGFloat {
            if self == .share {
                return 54
            }
            return 68
        }
    }

    class ItemView: UIButton {
        let item:MoreItem
        let icon: UIImageView = {
            let imageView = UIImageView()
            return imageView
        }()

        let title: UILabel = {
            let label = UILabel()
            label.font = .boldBody

            return label
        }()

        init(item: MoreItem) {
            self.item = item
            super.init(frame: .zero)
            addSubview(icon)
            addSubview(title)

            icon.image = item.image
            title.text = item.title
            title.textColor = item.color
            
            icon.snp.makeConstraints { make in
                make.left.equalTo(24)
                make.centerY.equalToSuperview()
            }
            
            title.snp.makeConstraints { make in
                make.left.equalTo(icon.snp.right).offset(25)
                make.centerY.equalToSuperview()
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    let stackContainer: UIStackView =  {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    let sections: [MoreSection] = []
    var moreActionCallback: Action2<FieldModel, MoreItem>?
    let field: FieldModel

    init(field: FieldModel) {
        self.field = field
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(stackContainer)
        stackContainer.snp.makeConstraints { make in
            make.top.equalTo(5)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        
        let sections = [
            [
                MoreItem.share
            ],
            [
                MoreItem.info,
                MoreItem.dew
            ],
            [
                MoreItem.hide,
                MoreItem.report
            ]
            
        ]
        
        updata(sections: sections)
    }
    
    override var backgroundType: BackgroundType {
        return .none
    }
    
    func updata(sections: [MoreSection]) {
        
        for (_, section) in sections.enumerated() {
            let sectionStackView = UIStackView()
            sectionStackView.layerCornerRadius = 16
            sectionStackView.axis = .vertical
            sectionStackView.backgroundColor = .cs_3D3A66_10
            for item in section {
                let btn = ItemView(item: item)
                btn.addTarget(self, action: #selector(itemClick(_:)), for: .touchUpInside)
                sectionStackView.addArrangedSubview(btn)
                btn.snp.makeConstraints { make in
                    make.height.equalTo(item.height)
                }
            }
            stackContainer.addArrangedSubview(sectionStackView)
        }
    }
    
    @objc func itemClick(_ itemView: ItemView) {
        dismiss(animated: true)
        moreActionCallback?(field, itemView.item)

    }
    
    
}
