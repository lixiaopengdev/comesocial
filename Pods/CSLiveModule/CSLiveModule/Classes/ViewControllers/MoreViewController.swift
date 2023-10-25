//
//  MoreViewController.swift
//  CSLiveModule
//
//  Created by fuhao on 2023/5/23.
//

import CSBaseView
//import CSRouter
//import CSNetwork
import CSListView
import CSMediator

private class BundleInternal {
    static func bundle() -> Bundle? {
        guard let url = Bundle(for: BundleInternal.self).url(forResource: "CSLiveModule", withExtension: "bundle") else {
            return nil
        }
        return Bundle(url: url)
    }
}

extension UIImage {
    static func bundleImage(named name: String) -> UIImage? {
        return UIImage(named: name, in: BundleInternal.bundle(), compatibleWith: nil)
    }
}


class MoreViewController: BaseViewController {
    
    typealias MoreSection = [MoreItem]
    typealias ReactionSection = [ReactionItem]
    
    class ReactionItemView: UIButton {
        let item:ReactionItem
        let icon: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()


        init(item: ReactionItem) {
            self.item = item
            super.init(frame: .zero)
            addSubview(icon)
            icon.image = item.image
            icon.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
                make.top.equalToSuperview().offset(7)
                make.bottom.equalToSuperview().offset(-7)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class ItemView: UIButton {
        var item:MoreItem!
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
            super.init(frame: .zero)
            addSubview(icon)
            addSubview(title)

            icon.snp.makeConstraints { make in
                make.left.equalTo(24)
                make.centerY.equalToSuperview()
            }
            
            title.snp.makeConstraints { make in
                make.left.equalTo(icon.snp.right).offset(25)
                make.centerY.equalToSuperview()
            }
            
            update(item: item)
        }
        
        func update(item: MoreItem) {
            self.item = item
            icon.image = item.image
            title.text = item.title
            title.textColor = item.color
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
    
    let reactionStackContainer: UIStackView =  {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    

    let requsestSessionID: String
    let timeDewId: UInt
    let timeDewType: String
    var isSaveTimeDew: Bool? = nil

    
    init(requsestSessionID: String, timeDewId: UInt, timeDewType: String,isSaveTimeDew: String?) {
        self.requsestSessionID = requsestSessionID
        self.timeDewId = timeDewId
        self.timeDewType = timeDewType
        if let isSaveTimeDew = isSaveTimeDew {
            self.isSaveTimeDew = Bool(isSaveTimeDew)
        }
        
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(reactionStackContainer)
        let separateLine = UIView()
        view.addSubview(separateLine)
        view.addSubview(stackContainer)
        
        
        reactionStackContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
        }
        
        separateLine.backgroundColor = .cs_darkGrey
        separateLine.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(reactionStackContainer.snp.bottom).offset(16)
        }

        stackContainer.snp.makeConstraints { make in
            make.top.equalTo(separateLine).offset(16)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
        
        var sections: [MoreSection] = []
        if timeDewType == "field" {
            sections.append([MoreItem.join])
        }else {
            sections.append([MoreItem.invite])
        }
        
        
        if let isSaveTimeDew = isSaveTimeDew {
            if isSaveTimeDew {
                sections.append([MoreItem.saved])
            }else {
                sections.append([MoreItem.save])
            }
        }
        


        sections.append([MoreItem.share])
        sections.append([MoreItem.feedback])
        updata(sections: sections)
        
        let reactionSections = [
            [
                ReactionItem.lol
            ],
            [
                ReactionItem.omg
            ],
            [
                ReactionItem.cool
            ],
            [
                ReactionItem.nooo
            ],
            [
                ReactionItem.damn
            ],
        ]
        
        updataReaction(sections: reactionSections)
    }
    
    override var backgroundType: BackgroundType {
        return .none
    }
    
    func updata(sections: [MoreSection]) {
        
        for (index, section) in sections.enumerated() {
            let sectionStackView = UIStackView()
            sectionStackView.layerCornerRadius = 16
            sectionStackView.axis = .vertical
            sectionStackView.backgroundColor = .cs_3D3A66_10
            for item in section {
                let btn = ItemView(item: item)
                btn.setBackgroundColor(color: .cs_darkGrey, forState: .highlighted)
                
                
                switch item {
                case .saved, .save:
                    btn.addTarget(self, action: #selector(persistentItemClick(_:)), for: .touchUpInside)
                    break
                    
                default:
                    btn.addTarget(self, action: #selector(itemClick(_:)), for: .touchUpInside)
                    break
                }
                
                
                sectionStackView.addArrangedSubview(btn)
                btn.snp.makeConstraints { make in
                    make.height.equalTo(item.height)
                }
            }
            stackContainer.addArrangedSubview(sectionStackView)
        }
    }
    
    
    func updataReaction(sections: [ReactionSection]) {
        
        for (index, section) in sections.enumerated() {
            let sectionStackView = UIStackView()
            sectionStackView.backgroundColor = .cs_3D3A66_10
            sectionStackView.layerCornerRadius = 16
            for item in section {
                let btn = ReactionItemView(item: item)
                btn.setBackgroundColor(color: .cs_darkGrey, forState: .highlighted)
                
                btn.addTarget(self, action: #selector(reactionItemClick(_:)), for: .touchUpInside)
                sectionStackView.addArrangedSubview(btn)
            }
            reactionStackContainer.addArrangedSubview(sectionStackView)
        }
    }
    
    
    @objc
    func itemClick(_ itemView: ItemView) {
        
        self.dismiss(animated: true)
        switch itemView.item {
        case .invite:
            notifyInfoBack(handleCode: 5)
            break
        case .join:
            notifyInfoBack(handleCode: 2)
            break
        case .share:
            notifyInfoBack(handleCode: 3)
            break
        case .feedback:
            notifyInfoBack(handleCode: 4)
            break
        default:
            break
        }
    }
    
    @objc
    func persistentItemClick(_ itemView: ItemView) {
        switch itemView.item {
        case .saved:
            
            Mediator.resolve(LiveService.TimeDewService.self)?.editlSaveTimeDew(id: Int(timeDewId), type: "time_dew", editHandle: 0)
//            Router.shared.open(Router.Live.editlSaveTimeDewHandlePath(id: Int(timeDewId), type: "time_dew", edit: 0))
            notifyInfoBack(handleCode: 0, params: ["toSave": false])
            itemView.update(item: .save)
            break
        case .save:
//            Router.shared.open(Router.Live.editlSaveTimeDewHandlePath(id: Int(timeDewId), type: "time_dew", edit: 1))
            Mediator.resolve(LiveService.TimeDewService.self)?.editlSaveTimeDew(id: Int(timeDewId), type: "time_dew", editHandle: 1)
            notifyInfoBack(handleCode: 0, params: ["toSave": true])
            itemView.update(item: .saved)
            break
        default:
            return
        }
    }
    
    @objc
    func reactionItemClick(_ itemView: ReactionItemView) {
        notifyInfoBack(handleCode: 1, params: ["reactionLabel": itemView.item.type])
        self.dismiss(animated: true)
    }
    
    
    fileprivate func notifyInfoBack(handleCode: UInt, params: [AnyHashable: Any] = [:]) {
        var userInfo: [AnyHashable: Any] = [
            "requsestSessionID": requsestSessionID,
            "timeDewId": timeDewId,
            "handleCode": handleCode,
        ]
        
        for (key, value) in params {
            userInfo[key] = value
        }
    
        NotificationCenter.default.post(name: Notification.Name("TimeDewFunctionNotification"), object: nil, userInfo: userInfo)
    }
    
//    fileprivate func jumpToField(fieldID: Int) {
//        if fieldID == 0 {
//            if let vc = Router.shared.viewController(for: Router.Field.myFieldPath()) {
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }else{
//            if let vc = Router.shared.viewController(for: Router.Field.fieldPath(id: UInt(fieldID))) {
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//
//            Network.oriRequest(LifeFlowService.jumpToField(fieldID: fieldID), completion:  { result in
//                print("jumpToField: \(result)")
//                switch result {
//                case .success(_):
//                    break
//
//                case .failure(_):
//                    break
//                }
//            })
//        }
//    }
//
//    fileprivate func sendUserJoinField(userID: String) {
//
//        Network.oriRequest(LifeFlowService.invite_join_field(user_id: userID), completion:  { [weak self] result in
//            print("invite user save: \(result)")
//            switch result {
//            case .success(_):
////                self?.showToast(message: "An invitation has been sent to the user!")
//                break
//
//            case .failure(_):
////                self?.showToast(message: "User invitation sending failed")
//                break
//            }
//        })
//    }
    
}
