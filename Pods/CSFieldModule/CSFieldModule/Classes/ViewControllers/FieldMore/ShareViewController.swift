//
//  ShareViewController.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/4/11.
//

import CSBaseView
import CSUtilities

class ShareViewController: BaseViewController {
    
    let stackContainer: UIStackView =  {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 32
        return stackView
    }()
    
    let scrollView: UIScrollView =  {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let items: [ShareItem] = []
    var shareActionCallback: Action2<FieldModel, ShareItem>?

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
        
        let lineView = UIView()
        lineView.backgroundColor = .cs_decoDarkPurple
        
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        let cancelLabel = UILabel()
        cancelLabel.text = "Cancel"
        cancelLabel.font = .regularHeadline
        cancelLabel.textColor = .cs_softWhite
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackContainer)
        view.addSubview(lineView)
        view.addSubview(cancelBtn)
        view.addSubview(cancelLabel)
        
        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(20)
            make.height.equalTo(76)
        }
        stackContainer.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalToSuperview()
            make.height.equalTo(76)
        }
        lineView.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(0.5)
            make.top.equalTo(scrollView.snp.bottom).offset(24)
        }
        cancelBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        cancelLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(26)
            make.centerX.equalToSuperview()
        }
        
        let items: [ShareItem] = [.discord, .link, .qrCode, .message, .airdrop]
        updata(items)
    }
    
    func updata(_ items: [ShareItem]) {
        
        for item in items {
            let btn = ItemView(item: item)
            btn.addTarget(self, action: #selector(itemClick(_:)), for: .touchUpInside)
            stackContainer.addArrangedSubview(btn)
            
        }
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc func itemClick(_ itemView: ItemView) {
        dismissVC()
        shareActionCallback?(field, itemView.item)
    }
    
    override var backgroundType: BackgroundType {
        return .none
    }
}


extension ShareViewController {
    enum ShareItem {
        case discord
        case link
        case qrCode
        case message
        case airdrop
        
        var image: UIImage? {
            switch self {
            case .discord:
                return UIImage.bundleImage(named: "share_discord")
            case .link:
                return UIImage.bundleImage(named: "share_link")
            case .qrCode:
                return UIImage.bundleImage(named: "share_qr")
            case .message:
                return UIImage.bundleImage(named: "share_message")
            case .airdrop:
                return UIImage.bundleImage(named: "share_airdrop")
            }
        }
        
        var title: String {
            switch self {
            case .discord:
                return "Discord"
            case .link:
                return "Link"
            case .qrCode:
                return "QR Code"
            case .message:
                return "Message"
            case .airdrop:
                return "Airdrop"
            }
        }
    }
}

extension ShareViewController {
    
    class ItemView: UIButton {
        let icon: UIImageView = {
            let imageView = UIImageView()
            return imageView
        }()

        let title: UILabel = {
            let label = UILabel()
            label.textColor = .cs_softWhite2
            label.textAlignment = .center
            label.font = .regularCaption1
            return label
        }()

        let item: ShareItem
        init(item: ShareItem) {
            self.item = item
            super.init(frame: .zero)
            addSubview(icon)
            addSubview(title)

            icon.image = item.image
            title.text = item.title
            
            icon.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
                make.size.equalTo(CGSize(width: 52, height: 52))
            }
            
            title.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(icon.snp.bottom).offset(7)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
            return CGSize(width: 52, height: 76)
        }
    }
    
}

