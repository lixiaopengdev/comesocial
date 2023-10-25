//
//  CSAlertController.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/5/10.
//


public class CSAlertController: UIViewController {
    
    public enum Style {
        case red(cancel: Bool)
        case pure(cancel: Bool)
        
        var autoCancel: Bool {
            switch self {
            case .red(cancel: let cancel):
                return cancel
            case .pure(cancel: let cancel):
                return cancel
            }
        }
    }
    
    public struct Action {
        public let title: String?
        public let style: Style
        public let handler: ((Action) -> Void)?
        
        public init(title: String?, style: Style, handler: ((Action) -> Void)? = nil) {
            self.title = title
            self.style = style
            self.handler = handler
        }
    }
    
    let containerView: UIView = {
       let view = UIView()
        view.backgroundColor = .cs_pureWhite
        view.layerCornerRadius = 20
        return view
    }()
    
    let alertTitle: String?
    let alertMessage: String?
    
    var titleLabel: UILabel?
    var messageLabel: UILabel?

    
    public init(title: String?, message: String?) {
        alertTitle = title
        alertMessage = message
        super.init(nibName: nil, bundle: nil)
    }
    
    var actions: [Action] = []
    
    public func addAction(_ action: Action) {
        actions.append(action)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .red
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.equalTo(60)
            make.right.equalTo(-60)
            make.centerY.equalTo(view.snp.centerY).offset(-56)
        }
        
        if let title = alertTitle {
            let label = UILabel()
            label.textAlignment = .center
            label.numberOfLines = 0
            label.font = .boldHeadline
            label.textColor = .cs_darkBlue
            label.text = title
            containerView.addSubview(label)
            label.snp.makeConstraints { make in
                make.top.equalTo(24)
                make.left.equalTo(16)
                make.right.equalTo(-16)
            }
            titleLabel = label
        }
        
        if let message = alertMessage {
            let label = UILabel()
            label.textAlignment = .center
            label.font = .regularSubheadline
            label.textColor = .cs_darkGrey
            label.numberOfLines = 0
            label.text = message
            containerView.addSubview(label)
            label.snp.makeConstraints { make in
                if let titleL = titleLabel {
                    make.top.equalTo(titleL.snp.bottom).offset(16)
                } else {
                    make.top.equalTo(24)
                }
                make.left.equalTo(32)
                make.right.equalTo(-32)
            }
            self.messageLabel = label
        }
        
     
        let actionContainer = UIStackView()
        actionContainer.axis = .vertical
        actionContainer.spacing = 4
        containerView.addSubview(actionContainer)
        actionContainer.snp.makeConstraints { make in
            make.left.equalTo(35)
            make.right.equalTo(-35)
            make.bottom.equalTo(-16)
            if let topL = messageLabel ?? titleLabel {
                make.top.equalTo(topL.snp.bottom).offset(24)
            } else {
                make.top.equalTo(24)
            }
        }
        for (index, action) in actions.enumerated() {
            let isRed = {
                if case .red = action.style { return true }
                return false
            }()
            let btn = UIButton(type: isRed ? .custom : .system)
            btn.setTitle(action.title, for: .normal)
            btn.layerCornerRadius = 22
            btn.tag = index
        
            btn.addTarget(self, action: #selector(clickAction(btn:)), for: .touchUpInside)
            switch action.style {
            case .red:
                btn.setTitleColor(.cs_pureWhite, for: .normal)
                btn.setBackgroundImage(UIImage(color: .cs_primaryPink, size: CGSize(width: 1, height: 1)), for: .normal)
            case .pure:
                btn.setTitleColor(.cs_darkGrey, for: .normal)
            }
            actionContainer.addArrangedSubview(btn)
            btn.snp.makeConstraints { make in
                make.height.equalTo(44)
            }
        }
        
    }
    
    @objc func clickAction(btn: UIButton) {
        let action = actions[btn.tag]
        action.handler?(action)
        if action.style.autoCancel {
            dismiss(animated: true)
        }
    }
}
