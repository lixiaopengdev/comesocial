//
//  FriendSearchBaseViewController.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/6/14.
//

import CSBaseView
import CSUtilities
import CSNetwork
import CSCommon
import Combine
import CSListView
import IGListKit

class FriendSearchBaseViewController: BaseViewController {
    
    private let searchBar = CSSearchBar()
    private var cancellableSet = Set<AnyCancellable>()
    private var serchCancellable: AnyCancellable?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        search(text: "")
    }
    
    private func updateUsers(userList: UserList) {
        
        data.removeAll()
        
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
    
    func search(text: String) {
        fatalError("子类实现")
    }
    
    func sendRequest(_ target: FriendService) {
        serchCancellable?.cancel()
        serchCancellable = Network.requestPublisher(target).mapModel(UserList.self).sink(success: { [weak self] userList in
            self?.updateUsers(userList: userList)
        }, failure: { error in
            
        })
    }
    
}

extension FriendSearchBaseViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(text: searchText)
    }
}

extension FriendSearchBaseViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
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
        return serchCancellable == nil ? nil : EmptyBackgroundView(style: .noContent(""))
    }
    
}

extension FriendSearchBaseViewController: UserSectionControllerDelegate {
    func userSectionControllerDidTapRightButton(_ sectionController: UserSectionController) {
        guard let object = adapter.object(for: sectionController) as? UserViewModel,
              let action = object.rightActionUrl  else { return }
        Network.requestPublisher(FriendService.action(url: action)).mapVoid().sink(success: { [weak self] _ in
            self?.search(text: self?.searchBar.text ?? "")
        }, failure: { error in
            HUD.showError(error.errorTips ?? "")
        }).store(in: &cancellableSet)
    }
    
    func userSectionControllerDidTapleftButton(_ sectionController: UserSectionController) {
        
    }
    
}
