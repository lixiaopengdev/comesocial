//
//  CSActionSheetController.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/6/16.
//


public class CSActionSheetController: UIViewController, Transitionable {
    
    public typealias Section = [Action]

    let stackContainer: UIStackView =  {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    var height: CGFloat = 0
    var headerHeight: CGFloat = 0
    var sections: [Section] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(stackContainer)
        stackContainer.snp.makeConstraints { make in
            make.top.equalTo(6)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
    }
    
    public func setSections(_ sections: [Section]) {
        self.sections = sections
        for subView in stackContainer.subviews {
            subView.removeFromSuperview()
        }
        updata(sections: sections)
    }
    
    public func setHeaderView(_ headerView: UIView, height: CGFloat) {
        stackContainer.addArrangedSubview(headerView)
        stackContainer.setCustomSpacing(0, after: headerView)
        headerView.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        headerHeight = height
    }
    
    func updata(sections: [Section]) {
        height = 0
        height += 6
        for (_, section) in sections.enumerated() {
            let sectionStackView = UIStackView()
            sectionStackView.layerCornerRadius = 16
            sectionStackView.axis = .vertical
            sectionStackView.backgroundColor = .cs_3D3A66_10
            sectionStackView.spacing = 2
            for item in section {
                let btn = ItemView(item: item)
                btn.addTarget(self, action: #selector(itemClick(_:)), for: .touchUpInside)
                sectionStackView.addArrangedSubview(btn)
                btn.snp.makeConstraints { make in
                    make.height.equalTo(54)
                }
                height += 56
            }
            if section.count >= 2 {
                let topView = UIView()
                topView.snp.makeConstraints { make in
                    make.height.equalTo(11)
                }
                
                let bottomView = UIView()
                bottomView.snp.makeConstraints { make in
                    make.height.equalTo(11)
                }
                sectionStackView.insertArrangedSubview(topView, at: 0)
                sectionStackView.addArrangedSubview(bottomView)
                
                height += 26
            }
            height -= sectionStackView.spacing
            stackContainer.addArrangedSubview(sectionStackView)
            sectionStackView.snp.makeConstraints { make in
                make.left.equalTo(12)
                make.right.equalTo(-12)
            }
            height += stackContainer.spacing
        }
        
        height -= stackContainer.spacing
        height += 36
    }
    
    @objc func itemClick(_ itemView: ItemView) {
        dismiss(animated: true)
        itemView.item.handler?(itemView.item)
    }
    
    public func transitioningDelegate() -> UIViewControllerTransitioningDelegate {
        return LineSheetTransition(height: height + headerHeight, timeInterval: 0.25)
    }
}


extension CSActionSheetController {
    public enum Style {
        case defalut
        case red
        
        var color: UIColor {
            switch self {
            case .defalut:
                return .cs_softWhite
            case .red:
                return .cs_systemRed
            }
        }
    }
    
    public struct Action {
        public let title: String
        public let image: UIImage?
        public let style: Style
        public let cancel: Bool
        public let handler: ((Action) -> Void)?
        
        public init(title: String, image: UIImage?, style: Style = .defalut, cancel: Bool = true, handler: ( (Action) -> Void)? = nil) {
            self.title = title
            self.image = image
            self.style = style
            self.cancel = cancel
            self.handler = handler
        }
    }
}

extension CSActionSheetController {
    class ItemView: UIButton {
        let item: Action
        let icon: UIImageView = {
            let imageView = UIImageView()
            return imageView
        }()

        let title: UILabel = {
            let label = UILabel()
            label.font = .boldBody

            return label
        }()

        init(item: Action) {
            self.item = item
            super.init(frame: .zero)
            addSubview(icon)
            addSubview(title)

            icon.image = item.image
            title.text = item.title
            title.textColor = item.style.color
            
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
}
