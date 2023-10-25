//
//  HiddenUserViewController.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/5/15.
//

import CSBaseView
import CSUtilities
import CSNetwork
import CSCommon
import Combine
import CSListView
import IGListKit

class HiddenUserViewController: BaseViewController {
    
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
        
        navigationItem.title = "Hidden User"
        
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

    func update(models: [HiddenUserModel]) {
        data.removeAll()
        let users = models.map { user in
            UserViewModel(section: "" ,id: user.id, name: user.name, subTitle: nil, avatar: user.avatar, online: user.online, relationIcon: nil, rightAction: .enable("Recover", url: nil), leftAction: .hide)
//            
//            UserViewModel(section: "" ,id: user.id, name: user.name, subTitle: user.subTitle, avatar: user.avatar, online: user.online, relationIcon: nil, rightAction: .enable("Accept", url: nil), leftAction: .enableDark("Decline", url: nil))
        }
        data.append("Search" as NSString)
        data.append(contentsOf: users)
        adapter.performUpdates(animated: true)
    }
    
    override var backgroundType: BackgroundType {
        return .dark
    }
    
    private func search() {
        serchCancellable?.cancel()
        serchCancellable = Network.requestPublisher(FriendService.searchHiddenUsers(key: searchText)).mapModels(HiddenUserModel.self).sink(success: { [weak self] models in
            self?.update(models: models)
        }, failure: { error in
            
        })
    }
}

extension HiddenUserViewController: SearchSectionControllerDelegate {
    func searchSectionControllerTextDidChange(_ sectionController: ListSectionController, searchText: String) {
        self.searchText = searchText
        search()
    }
    
}

extension HiddenUserViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is NSString:
            let sectionController = SearchSectionController()
            sectionController.delegate = self
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

extension HiddenUserViewController: UserSectionControllerDelegate {
    func userSectionControllerDidTapRightButton(_ sectionController: UserSectionController) {
        guard let object = adapter.object(for: sectionController) as? UserViewModel else { return }
        if let index = data.firstIndex(where: { user in
            return user.diffIdentifier() === object.diffIdentifier()
        }) {
            data.remove(at: index)
        }
        Network
            .requestPublisher(FriendService.recoverHiddenUsers(id: object.id))
            .mapVoid()
            .sink { _ in
                
            } failure: { [weak self] error in
                self?.search()
                HUD.showError(error)
            }
            .store(in: &cancellableSet)
        adapter.performUpdates(animated: true)
    }
    
    func userSectionControllerDidTapleftButton(_ sectionController: UserSectionController) {
        
    }
    
}

extension HiddenUserViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 20 && scrollView.contentOffset.y > 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } else if scrollView.contentOffset.y < 40 && scrollView.contentOffset.y > 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 40), animated: true)
        }
        
    }
}
