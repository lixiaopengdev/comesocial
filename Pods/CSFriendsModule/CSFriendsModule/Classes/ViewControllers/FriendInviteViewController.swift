//
//  FriendInviteViewController.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/5/15.
//

import CSBaseView
import CSUtilities
import CSNetwork
import CSCommon
import Combine
//import CSRouter
import CSListView
import IGListKit

class FriendInviteViewController: BaseViewController {
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var cancellableSet = Set<AnyCancellable>()
    var data: [ListDiffable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Add Friends"
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        updateUsers()
    }
    
    func updateUsers() {
        Network.request(FriendService.inviteFriends, type: FriendInviteModel.self) { [weak self] friendInvite in
            self?.configSections(friendInvite: friendInvite)
        }
    }
    
    func configSections(friendInvite: FriendInviteModel) {
        data.removeAll()
        // data.append((friendInvite.link ?? "") as NSString)
        data.append(FoldViewModel(leftTitle: "You Might  Know Them", rightTitle: nil, fold: nil))
        let users = friendInvite.users.map { user in
            UserViewModel(section: "" ,id: user.id, name: user.name, subTitle: user.subTitle, avatar: user.avatar, online: user.online, relationIcon: nil, rightAction: user.rightViewModelStyle, leftAction: .hide)
        }
        data.append(contentsOf: users)
        adapter.performUpdates(animated: true)
    }
    
    override var backgroundType: BackgroundType {
        return .dark
    }
    
}

extension FriendInviteViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is NSString:
            return FriendInviteSectionController()
        case is FoldViewModel:
            let sectionController = FoldSectionController()
            return sectionController
        default:
            let sectionController = UserSectionController()
            sectionController.delegate = self
            return sectionController
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

extension FriendInviteViewController: UserSectionControllerDelegate {
    func userSectionControllerDidTapRightButton(_ sectionController: UserSectionController) {
        guard let object = adapter.object(for: sectionController) as? UserViewModel,
              let action = object.rightActionUrl  else { return }
        Network.requestPublisher(FriendService.action(url: action)).mapVoid().sink(success: { [weak self] _ in
            self?.updateUsers()
        }, failure: { error in
            HUD.showError(error.errorTips ?? "")
        }).store(in: &cancellableSet)
    }
    
    func userSectionControllerDidTapleftButton(_ sectionController: UserSectionController) {
        
    }
    
}
