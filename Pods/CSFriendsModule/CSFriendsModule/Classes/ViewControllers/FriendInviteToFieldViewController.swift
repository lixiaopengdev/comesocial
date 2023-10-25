//
//  FriendInviteToFieldViewController.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/6/7.
//

import CSBaseView
import CSUtilities
import CSNetwork
import CSCommon
import Combine
//import CSRouter
import CSListView
import IGListKit

class FriendInviteToFieldViewController: BaseViewController {
    
    private var serchCancellable: AnyCancellable?
    private var cancellableSet = Set<AnyCancellable>()
    
    var data: [ListDiffable] = []
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
    
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Invite Friends"
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        search()
        
    }
    
    private func updateUsers(userList: UserList) {
        data.removeAll()
        
        data.append("Search" as NSString)
        let suggestedUsers = userList.suggested.map { user in
            UserViewModel(section: "1", id: user.id, name: user.name, subTitle: user.subTitle, avatar: user.avatar, online: user.online, relationIcon: user.relation, rightAction: user.rightViewModelStyle, leftAction: .hide)
        }
        if !suggestedUsers.isEmpty {
            data.append(FoldViewModel(leftTitle: "Suggested", rightTitle: nil, fold: nil))
            data.append(contentsOf: suggestedUsers)
        }
        
        let moreUsers = userList.more.map { user in
            UserViewModel(section: "2", id: user.id, name: user.name, subTitle: user.subTitle, avatar: user.avatar, online: user.online, relationIcon: user.relation, rightAction: user.rightViewModelStyle, leftAction: .hide)
        }
        if !moreUsers.isEmpty {
            data.append(FoldViewModel(leftTitle: "More", rightTitle: nil, fold: nil))
            data.append(contentsOf: moreUsers)
        }
        adapter.performUpdates(animated: true)
    }
    
    
    @objc func addClick() {
        navigationController?.pushViewController(FriendAddViewController(), animated: true)
    }
    
    private func search() {
        serchCancellable?.cancel()
        serchCancellable = Network.requestPublisher(FriendService.inviteFieldFriends(name: searchText)).mapModel(UserList.self).sink(success: { [weak self] userList in
            self?.updateUsers(userList: userList)
        }, failure: { error in
            
        })
    }
    
    override var backgroundType: BackgroundType {
        return .dark
    }
}

extension FriendInviteToFieldViewController: SearchSectionControllerDelegate {
    func searchSectionControllerTextDidChange(_ sectionController: ListSectionController, searchText: String) {
        self.searchText = searchText
        search()
    }

}

extension FriendInviteToFieldViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is NSString:
            let sectionController = SearchSectionController()
            sectionController.delegate = self
            return sectionController
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

extension FriendInviteToFieldViewController: UserSectionControllerDelegate {
    func userSectionControllerDidTapRightButton(_ sectionController: UserSectionController) {
        guard let object = adapter.object(for: sectionController) as? UserViewModel,
              let action = object.rightActionUrl  else { return }
        Network.requestPublisher(FriendService.action(url: action)).mapVoid().sink(success: { [weak self] _ in
            self?.search()
        }, failure: { error in
            HUD.showError(error.errorTips ?? "")
        }).store(in: &cancellableSet)
    }
    
    func userSectionControllerDidTapleftButton(_ sectionController: UserSectionController) {
        
    }
    
}

extension FriendInviteToFieldViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 20 && scrollView.contentOffset.y > 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } else if scrollView.contentOffset.y < 40 && scrollView.contentOffset.y > 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 40), animated: true)
        }
                
    }
}
