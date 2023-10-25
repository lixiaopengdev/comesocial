//
//  UserMoreViewController.swift
//  CSCommon
//
//  Created by 于冬冬 on 2023/6/6.
//

import CSBaseView
import CSUtilities


class UserMoreViewController: BaseViewController {
    
    typealias MoreSection = [MoreItem]
    
    enum MoreItem {
        case invite
        case share
        case breakConnections
        case hide
        case report
        case recover

        var image: UIImage? {
            switch self {
            case .share:
                return UIImage.bundleImage(named: "button_icon_share")
            case .hide, .recover:
                return UIImage.bundleImage(named: "button_icon_solid_hide")
            case .report:
                return UIImage.bundleImage(named: "button_icon_report")
            case .invite:
                return UIImage.bundleImage(named: "button_icon_invite")
            case .breakConnections:
                return UIImage.bundleImage(named: "button_icon_break_connection")
            }
        }
        
        var title: String {
            switch self {
            case .share:
                return "Share"
            case .hide:
                return "Hide"
            case .report:
                return "Report"
            case .invite:
                return "Invite"
            case .breakConnections:
                return "Break Connection"
            case .recover:
                return "Recover"
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
    var sections: [MoreSection] = []
    var moreActionCallback: Action1<MoreItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(stackContainer)
        stackContainer.snp.makeConstraints { make in
            make.top.equalTo(5)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        
        
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
        moreActionCallback?(itemView.item)

    }
    
    
}
