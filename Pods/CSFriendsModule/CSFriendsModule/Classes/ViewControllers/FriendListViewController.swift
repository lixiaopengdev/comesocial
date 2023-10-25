
import CSBaseView
import SnapKit
import CSAccountManager
import CSNetwork
import CSUtilities
import CSCommon
import CSListView
import IGListKit
import CSMediator

class FriendListViewController: BaseViewController {
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    var header: NSString = "header"
    var notices: [NoticeViewModel] = []
    var bestTitle: FoldViewModel?
    var closeTitle: FoldViewModel?
    var friendsTitle: FoldViewModel?
    var bestFriends: [UserViewModel] = []
    var closeFriends: [UserViewModel] = []
    var friends: [UserViewModel] = []
    
    var data: [ListDiffable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showVoiceBar()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage.bundleImage(named: "corner_add_light"), target: self, action: #selector(addClick)),
            UIBarButtonItem(image: UIImage.bundleImage(named: "corner_search_light"), target: self, action: #selector(searchClick))
        ]
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Network.request(FriendService.friends, type: FriendListModel.self) { [weak self] friendList in
            self?.configSections(friendList: friendList)
        }
    }
    
    func configSections(friendList: FriendListModel?) {
        guard let friendList = friendList else {
            return
        }
        notices = friendList.notices.map { notice in
            NoticeViewModel(content: notice.content, avatars: notice.avatars)
        }
        
        // bestFriends
        
        var onlineCount = 0
        bestFriends = friendList.closeFriends.map { user in
            if user.online {
                onlineCount += 1
            }
            return UserViewModel(section: "1", id: user.id, name: user.name, subTitle: user.subTitle, avatar: user.avatar, online: user.online, relationIcon: user.relation, rightAction: .hide, leftAction: .hide)
        }
        let bestRightAttr = NSAttributedString(string: "\(onlineCount)/\(bestFriends.count)").font(.regularCaption1)
        bestTitle = FoldViewModel(leftTitle: "Best Friends", rightAttributedTitle: bestRightAttr, fold: bestTitle?.fold ?? false)
        
        // closeFriends
        onlineCount = 0
        closeFriends = friendList.friends.map { user in
            if user.online {
                onlineCount += 1
            }
            return UserViewModel(section: "1", id: user.id, name: user.name, subTitle: user.subTitle, avatar: user.avatar, online: user.online, relationIcon: user.relation, rightAction: .hide, leftAction: .hide)
            
        }
        let closeRightAttr = NSAttributedString(string: "\(onlineCount)/\(closeFriends.count)").font(.regularCaption1)
        closeTitle = FoldViewModel(leftTitle: "Close Friends", rightAttributedTitle: closeRightAttr, fold: closeTitle?.fold ?? false)
        
        // friends
        onlineCount = 0
        friends = friendList.all.map { user in
            if user.online {
                onlineCount += 1
            }
            return UserViewModel(section: "1", id: user.id, name: user.name, subTitle: user.subTitle, avatar: user.avatar, online: user.online, relationIcon: user.relation, rightAction: .hide, leftAction: .hide)
            
        }
        let friendsRightAttr = NSAttributedString(string: "\(onlineCount)/\(friends.count)").font(.regularCaption1)
        friendsTitle = FoldViewModel(leftTitle: "Friends", rightAttributedTitle: friendsRightAttr, fold: friendsTitle?.fold ?? false)
        updateUI()
    }
    
    func updateUI() {
        data.removeAll()
        
        data.append(header)
        data.append(contentsOf: notices)
//        if let bestTitle = bestTitle {
//            data.append(bestTitle)
//            if bestTitle.fold == false {
//                data.append(contentsOf: bestFriends)
//            }
//        }
//        if let closeTitle = closeTitle {
//            data.append(closeTitle)
//            if closeTitle.fold == false {
//                data.append(contentsOf: closeFriends)
//            }
//        }
        if let friendsTitle = friendsTitle {
            data.append(friendsTitle)
            if friendsTitle.fold == false {
                data.append(contentsOf: friends)
            }
        }
        adapter.performUpdates(animated: true)
    }
    
    
    @objc func searchClick() {
        navigationController?.pushViewController(FieldSearchViewController(), animated: true)
    }
    
    @objc func addClick() {
        
        navigationController?.pushViewController(FriendAddViewController(), animated: true)
        
    }
    
    override func toField() {
        if let vc = Mediator.resolve(FieldService.ViewControllerService.self)?.myFieldViewController() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension FriendListViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is NSString:
            return FriendListHeaderSectionController()
        case is FoldViewModel:
            let sectionController = FoldSectionController()
            sectionController.delegate = self
            return sectionController
        case is NoticeViewModel:
            let sectionController = NoticeSectionController()
            return sectionController
        default:
            return UserSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

extension FriendListViewController: FoldSectionControllerDelegate {
    func foldSectionControllerDidTapRightArea(_ cell: FoldSectionController) {
        
    }
    
    func foldSectionControllerDidTapleftArea(_ cell: FoldSectionController, fold: Bool) {
        updateUI()
    }
    
}
