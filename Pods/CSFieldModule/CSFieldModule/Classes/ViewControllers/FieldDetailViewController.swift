//
//  FieldDetailViewController.swift
//  CSCommon
//
//  Created by 于冬冬 on 2023/5/19.
//

import CSBaseView
import CSUtilities
import CSNetwork
//import CSRouter
import CSCommon

class FieldDetailViewController: BaseViewController {
    
//    enum Style {
//        case info
//        case timeDew
//    }
//    
//    lazy var fieldView = CSListView()
//    
//    let bottomImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage.bundleImage(named: "field_detail_gradient_background")
//        imageView.isUserInteractionEnabled = true
//        return imageView
//    }()
//
//    lazy var joinButton: CSGradientButton = {
//        let button = CSGradientButton()
//        button.layerCornerRadius = 12
//        button.setTitle("Join", for: .normal)
//        button.setImage(UIImage.bundleImage(named: "button_icon_join"), for: .normal)
//        button.imageTextSpacing = 8
//        button.addTarget(self, action: #selector(joinClick), for: .touchUpInside)
//        return button
//    }()
//    
//    let field: FieldModel
//    let style: Style
//    init(field: FieldModel, style: Style) {
//        self.field = field
//        self.style = style
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        navigationItem.title = field.name
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.bundleImage(named: "corner_share_dark"), target: self, action: #selector(shareClick))
//        
//        
//        view.addSubview(fieldView)
//        view.addSubview(bottomImageView)
//        bottomImageView.addSubview(joinButton)
//        
//        fieldView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.left.right.bottom.equalToSuperview()
//        }
//        bottomImageView.snp.makeConstraints { make in
//            make.left.bottom.right.equalToSuperview()
//            make.height.equalTo(124)
//        }
//        joinButton.snp.makeConstraints { make in
//            make.width.equalTo(173)
//            make.centerX.equalToSuperview()
//            make.height.equalTo(52)
//            make.bottom.equalTo(bottomImageView.safeAreaLayoutGuide.snp.bottom).offset(-14)
//        }
//        
//        switch style {
//        case .info:
//            var cardItems: [CSCommon.CardDisplay] = []
//            for index in 0...10 {
//                cardItems.append(AnyCardDisplay(id: UInt(index), icon: "https://succuland.com.tw/wp-content/uploads/2022/01/%E9%81%87%E8%A6%8B%E4%BD%A0%E6%98%AF%E6%88%91%E4%BA%BA%E7%94%9F%E4%B8%AD%E6%9C%80%E5%B9%B8%E7%A6%8F%E4%B9%9F%E6%9C%80%E5%B9%B8%E9%81%8B%E7%9A%84%E4%BA%8B%E6%83%85.jpg"))
//            }
//            
//            var users: [CSCommon.AnyFriendItemDisplay] = []
//            for index in 0...10 {
//                users.append(AnyFriendItemDisplay(id: UInt(index), name: "user \(index)", avatar: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fsafe-img.xhscdn.com%2Fbw1%2F4d2a8885-131d-4530-835a-0ee12ae4201b%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fsafe-img.xhscdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1683105048&t=858875bf4e253fe95ef0534174afd65e", online: index % 2 == 0, rightAction: .hide))
//            }
//            
//            let cardsSection = AnySectionDisplay(leftTitle: "Cards in field", fold: false, items: [AnyCardsItemDisplay(cards: cardItems)])
//            let usersSection = AnySectionDisplay(leftTitle: "Users in field", fold: false, items: users)
//           
//            self.fieldView.reloadSections([cardsSection, usersSection])
//        case .timeDew:
//            var timeDews: [TimeDewItemDisplay] = []
//            for index in 0...10 {
////                timeDews.append(AnyTimeDewItemDisplay(des: "test time dew \(index)"))
//            }
//            
//            let timeDewsSection = AnySectionDisplay(leftTitle: "Time Dews", fold: nil, items: timeDews)
//           
//            self.fieldView.reloadSections([ timeDewsSection])
//        }
//        
//        
//        fieldView.cellClickCallback = {[weak self] (item, indexPath) in
//            self?.cellClick(item, indexPath)
//        }
//        fieldView.rightBtnClickCallback = {[weak self] (item, indexPath) in
//            self?.rightBtnClick(item as! FriendItemDisplay, indexPath)
//        }
//        fieldView.sectionLeftClickCallback = {[weak self] (section, index) in
//            self?.sectionClick(section, index)
//        }
//    }
//    
//    func rightBtnClick(_ item: FriendItemDisplay, _ indexPath: IndexPath) {
//        var newItem = AnyFriendItemDisplay(display: item)
//        newItem.rightAction = .disable("Waiting...")
//        fieldView.updateCell(newItem, indexPath)
//    }
//    
//    func cellClick(_ item: ItemDisplay, _ indexPath: IndexPath) {
//        if let item = item as? FriendItemDisplay {
//            Router.shared.push(Router.Field.userPath(uid: item.id))
//        }
//    }
//    
//    func sectionClick(_ section: SectionDisplay, _ index: Int) {
//        let newSection = AnySectionDisplay(display: section)
//        if let fold = section.fold {
//            newSection.fold = !fold
//        }
//        self.fieldView.updateSection(newSection, index)
//    }
//    
//    @objc func shareClick() {
//        
//    }
//    
//    @objc func joinClick() {
//        
//    }
//    
//    override var backgroundType: BackgroundType {
//        return .dark
//    }
//    
}
