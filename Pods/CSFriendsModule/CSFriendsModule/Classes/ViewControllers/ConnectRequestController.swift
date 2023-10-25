//
//  ConnectRequestController.swift
//  CSCommon
//
//  Created by 于冬冬 on 2023/6/7.
//

import CSBaseView
import CSUtilities
import CSNetwork
import CSCommon
import Combine
import CSListView
import IGListKit

class ConnectRequestController: BaseViewController {
    
    var cancellable = Set<AnyCancellable>()

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
        
        navigationItem.title = "Connection Request"
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
        adapter.collectionView = collectionView
        adapter.dataSource = self
        update()
    }
    
    func update() {
        Network.request(FriendService.connectRequest, type: ConnectRequestList.self) { [weak self] model in
            self?.update(models: model.users)
        }
    }
    
    func deal(id: UInt, accept: Bool) {
        Network
            .requestPublisher(FriendService.dealInvitation(id: id, type: "normal", accept: accept))
            .mapVoid()
            .sink { _ in
                
            } failure: { [weak self] error in
                HUD.showError(error)
                self?.update()
            }
            .store(in: &cancellable)
    }
    
    func update(models: [RequestUserModel]) {
        data.removeAll()
        let users = models.map { user in
            UserViewModel(section: "" ,id: user.id, name: user.name, subTitle: user.subTitle, avatar: user.avatar, online: user.online, relationIcon: nil, rightAction: .enable("Accept", url: nil), leftAction: .enableDark("Decline", url: nil))
            
        }
        data.append(contentsOf: users)
        adapter.performUpdates(animated: true)
    }
    
    override var backgroundType: BackgroundType {
        return .dark
    }
    
}


extension ConnectRequestController: ListAdapterDataSource {
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
        return nil
    }
    
}

extension ConnectRequestController: UserSectionControllerDelegate {
    func userSectionControllerDidTapRightButton(_ sectionController: UserSectionController) {
        guard let object = adapter.object(for: sectionController) as? UserViewModel else { return }
        deal(id: object.id, accept: true)
        if let index = data.firstIndex(where: { user in
            return user.diffIdentifier() === object.diffIdentifier()
        }) {
            data.remove(at: index)
        }
        adapter.performUpdates(animated: true)
        
        
    }
    
    func userSectionControllerDidTapleftButton(_ sectionController: UserSectionController) {
        guard let object = adapter.object(for: sectionController) as? UserViewModel  else { return }
        deal(id: object.id, accept: false)
        if let index = data.firstIndex(where: { user in
            return user.diffIdentifier() === object.diffIdentifier()
        }) {
            data.remove(at: index)
        }
        adapter.performUpdates(animated: true)
    }
    
}
