

import CSBaseView
import SnapKit
import CSAccountManager
import CSUtilities
import Foundation
import CSNetwork
import Combine
import CSListView
import IGListKit
import Kingfisher
import CSMediator
import CSCommon

class ProfileViewController: BaseViewController {
    
    private var cancellableSet = Set<AnyCancellable>()
    private var data: [ListDiffable] = []
    private var tempReqesutSessionId: String = "xxx"
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        AccountManager.shared.$isLogin.removeDuplicates().receive(on: RunLoop.main).sink { login in
            if login {
                MyProfileManager.share.updateMyProfile()
                MyProfileManager.share.updateCollections()
            } else {
            }
        }.store(in: &cancellableSet)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MyProfileManager.share.updateMyProfile()
        MyProfileManager.share.updateCollections()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage.bundleImage(named: "corner_setting_light"), target: self, action: #selector(settingClick)),
            UIBarButtonItem(image: UIImage.bundleImage(named: "corner_edit_light"), target: self, action: #selector(editClick))
        ]
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        
        MyProfileManager.share.userPublisher
            .sink { [weak self] user in
                self?.update()
            }
            .store(in: &cancellableSet)
        
        MyProfileManager.share.collectionsPublisher
            .sink { [weak self] user in
                self?.update()
            }
            .store(in: &cancellableSet)
        
//        self.navigationController.tabBarItem.selectedImage = UIImage(named: selecedImage)?.withRenderingMode(.alwaysOriginal)
    }
    
    private func update() {
        
        data.removeAll()
        if let userModel = MyProfileManager.share.user {
            let userViewModel = ProfileHeaderViewModel(name: userModel.name , online: false, avatar: userModel.thumbnailUrl, subName: userModel.subName, bio: userModel.bio, labels: userModel.labels)
            data.append(userViewModel)
            
            if userModel.status == .multi {
                data.append(ProfileButtonViewModel(title: "In Field now...", image: nil, enable: false))
            }
            let open = userModel.isShowCollections ?? false
            data.append(SwitchViewModel(title: "Collection", openSubtitle: "Visible to public", closeSubtitle: "Invisible to public", isOpen: open))
            
            let collections = MyProfileManager.share.collections.map { model in
                
                let timeDewReactionCellModels = model.reactions?.compactMap { (key, value) in
                    return TimeDewReactionCellModel(reactionLabel: key, reactionUsers: value)
                }.sorted { $0.reactionLabel < $1.reactionLabel }
                
                return TimeDewViewModel(id: model.id,
                                        type: nil,
                                        icon: model.onwerThumb,
                                        title: model.title,
                                        timeStamp: model.timeStamp,
                                        content: model.content,
                                        imageContent: model.pic,
                                        reactions: timeDewReactionCellModels,
                                        isSave: model.isSave,
                                        fieldID: model.fieldID,
                                        onwerID: nil,
                                        members: model.members,
                                        members_thumbs: model.members_thumbs)

            }
            data.append(contentsOf: collections)
        }
        adapter.performUpdates(animated: false)
    }
    
    @objc private func editClick() {
        navigationController?.pushViewController(EditProfileViewController(), animated: true)
    }
    
    @objc private func settingClick() {
        navigationController?.pushViewController(EditSettingViewController(), animated: true)
    }
}

extension ProfileViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is ProfileHeaderViewModel: return ProfileHeadSectionController()
        case is SwitchViewModel:
            let sectionController = SwitchSectionController()
            sectionController.delegate = self
            return sectionController
        case is ProfileButtonViewModel:
            let sectionController = ProfileButtonSectionController()
            return sectionController
        default:
            let timeDewSectionController = TimeDewSectionController()
            timeDewSectionController.timeDewDelegate = self
            return timeDewSectionController
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

extension ProfileViewController: SwitchSectionControllerDelegate {
    func switchSectionControllerDidValueChanged(_ sectionController: CSListView.SwitchSectionController, value: Bool) {
        Network
            .requestPublisher(UserService.openCollection(open: value))
            .mapVoid()
            .sink(success: { _ in
                MyProfileManager.share.user?.isShowCollections = value
            }, failure: { [weak self] error in
                self?.update()
                HUD.showError(error)
            })
            .store(in: &cancellableSet)
    }
}















extension ProfileViewController : TimeDewSectionDelegate {
    
    func onCellClick(model: CSListView.TimeDewViewModel) {
        showMoreViewController(item: model)
    }
    
    func onAvatarImageClick(model: CSListView.TimeDewViewModel) {
        guard let ownerID = model.onwerID else { return }
        guard let ownerIDII = UInt(ownerID) else { return }
        if let vc = Mediator.resolve(MeService.ViewControllerService.self)?.profileViewController(uid: ownerIDII) {
            Mediator.push(vc)
        }
//        Router.shared.push(Router.Me.profilePath(uid: ownerIDII))
    }
    
    func onImageContentClick(model: CSListView.TimeDewViewModel, image: UIImage) {
        showImageContent(image: image)
    }
    
    func onReactionClick(model: CSListView.TimeDewViewModel, reactionLabel: String) {
        switchReaction(model: model, reactionLabel: reactionLabel)
    }
}

extension ProfileViewController {
    fileprivate func jumpToField(fieldID: UInt) {
        if fieldID == 0 {
            
            if let vc = Mediator.resolve(FieldService.ViewControllerService.self)?.myFieldViewController() {
                Mediator.push(vc)
            }
//
//            if let vc = Router.shared.viewController(for: Router.Field.myFieldPath()) {
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        }else{
//            Router.shared.open(Router.Live.jumpFieldTimeDewPath(fieldId: fieldID))
            Mediator.resolve(LiveService.TimeDewService.self)?.jumpFieldTimeDew(fieldId: fieldID)
            if let vc = Mediator.resolve(FieldService.ViewControllerService.self)?.getFieldViewController(from: fieldID) {
                Mediator.push(vc)
            }
//            if let vc = Router.shared.viewController(for: Router.Field.fieldPath(id: fieldID)) {
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        }
    }
    
    
    @objc func closeFullscreenImage() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func scaleFullscreenImage(_ gesture: UIPinchGestureRecognizer) {
        guard let fullscreenImageView = gesture.view as? UIImageView else {
            return
        }
        
        if gesture.state == .changed {
            fullscreenImageView.transform = CGAffineTransform(scaleX: gesture.scale, y: gesture.scale)
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.3) {
                fullscreenImageView.transform = .identity
            }
        }
    }
    
    fileprivate func showImageContent(image: UIImage) {
        let fullscreenVC = UIViewController()
        fullscreenVC.modalPresentationStyle = .fullScreen
        fullscreenVC.view.backgroundColor = .black
        
        let fullscreenImageView = UIImageView(frame: fullscreenVC.view.bounds)
        fullscreenImageView.contentMode = .scaleAspectFit
        fullscreenImageView.image = image
        fullscreenImageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeFullscreenImage))
        fullscreenImageView.addGestureRecognizer(tapGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(scaleFullscreenImage(_:)))
        fullscreenImageView.addGestureRecognizer(pinchGesture)
        
        fullscreenVC.view.addSubview(fullscreenImageView)

        present(fullscreenVC, animated: true, completion: nil)
    }
    
    
    fileprivate func showMoreViewController(item: TimeDewViewModel) {
        tempReqesutSessionId = UUID().uuidString
        if let moreViewController = Mediator.resolve(LiveService.ViewControllerService.self)?.moreFunction(requestSessionId: tempReqesutSessionId, timeDewId: item.id, timeDewType: item.type ?? "", isSaveTimeDew: "true") {
            NotificationCenter.default.removeObserver(self)
            NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("TimeDewFunctionNotification"), object: nil)
            self.present(moreViewController, method: PresentTransitionMethod.lineSheet(height: 408, timeInterval: 0.2))
        }
    }
    
    
    @objc func handleNotification(_ notification: Notification) {
        guard notification.name == Notification.Name(rawValue: "TimeDewFunctionNotification") else { return }
        guard let userInfo = notification.userInfo else { return }
        guard let requsestSessionID = userInfo["requsestSessionID"] as? String,
              tempReqesutSessionId == requsestSessionID else { return }
        guard let handleCode = userInfo["handleCode"] as? UInt else {return}
        
        
        
        
        switch handleCode {
        case  0:
            guard let timeDewId = userInfo["timeDewId"] as? UInt else { return }
            guard let toSave = userInfo["toSave"] as? Bool else { return }
            
            guard let findObject = data.first(where: { item in
                guard let vm = item as? TimeDewViewModel,
                      vm.id == timeDewId else {
                    return false
                }
                return true
            }) else { return }
            guard let viewModel = findObject as? TimeDewViewModel else { return }
            
            viewModel.isSave = toSave
            
            break
        case 1 :

            guard let timeDewId = userInfo["timeDewId"] as? UInt else { return }
            guard let reactionLabel = userInfo["reactionLabel"] as? String else { return }

            
            guard let findObject = data.first(where: { item in
                guard let vm = item as? TimeDewViewModel,
                      vm.id == timeDewId else {
                    return false
                }
                return true
            }) else { return }
            guard let viewModel = findObject as? TimeDewViewModel else { return }
            
            switchReaction(model: viewModel, reactionLabel: reactionLabel)
            break
        case 2:

            guard let timeDewId = userInfo["timeDewId"] as? UInt else { return }
            guard let findObject = data.first(where: { item in
                guard let vm = item as? TimeDewViewModel,
                      vm.id == timeDewId else {
                    return false
                }
                return true
            }) else { return }
            guard let viewModel = findObject as? TimeDewViewModel else { return }
            guard let fieldID = viewModel.fieldID else { return }
            
            jumpToField(fieldID: fieldID)
            break
        case 3:

            guard let timeDewId = userInfo["timeDewId"] as? UInt else { return }
            guard let findObject = data.first(where: { item in
                guard let vm = item as? TimeDewViewModel,
                      vm.id == timeDewId else {
                    return false
                }
                return true
            }) else { return }
            guard let viewModel = findObject as? TimeDewViewModel else { return }
            guard let content = viewModel.content,
                  let title = viewModel.title else {
                return
            }

//            if let shareViewController = Router.shared.viewController(for: Router.Live.shareTimeDewPath(titleText: title, contentText: content, photoImageURL: viewModel.icon, contentImageURL: viewModel.imageContent)) {
//                self.navigationController?.pushViewController(shareViewController, animated: true)
//            }
            if let shareViewController = Mediator.resolve(LiveService.ViewControllerService.self)?.shareTimeDewViewController(titleText: title, contentText: content, photoImageURL: viewModel.icon, contentImageURL: viewModel.imageContent) {
                self.navigationController?.pushViewController(shareViewController, animated: true)
            }
            break
        case 4:

            guard let timeDewId = userInfo["timeDewId"] as? UInt else { return }
            guard let findObject = data.first(where: { item in
                guard let vm = item as? TimeDewViewModel,
                      vm.id == timeDewId else {
                    return false
                }
                return true
            }) else { return }
            guard let viewModel = findObject as? TimeDewViewModel else { return }
            guard let fieldID = viewModel.fieldID else { return }
            let reportVC = ReportViewController(type: .timeDew, id: String(fieldID))
            let nav = BaseNavigationController(rootViewController: reportVC)
            self.present(nav, animated: true)
            break
        default:
            break
        }
    }
    
    fileprivate func switchReaction(model: TimeDewViewModel, reactionLabel: String) {
        guard let modedIndex = data.firstIndex(where: {$0.isEqual(toDiffableObject: model)}) else {
            return
        }
        
        
        var addReaction = true
        defer {
//            if addReaction {
//                Router.shared.open(Router.Live.doReactionTimeDewPath(id: Int(model.id), type: reactionLabel, edit: 1))
//            }else {
//                Router.shared.open(Router.Live.doReactionTimeDewPath(id: Int(model.id), type: reactionLabel, edit: 0))
//            }
            
            Mediator.resolve(LiveService.TimeDewService.self)?.doReactionTimeDew(id: Int(model.id), type: reactionLabel, editHandle: addReaction ? 1 : 0)
            
            if let sectionController = self.adapter.sectionController(forSection: modedIndex),
               let timeDewSectionController = sectionController as? TimeDewSectionController {
                timeDewSectionController.didUpdate(to: model)
            }
        }
        
        
        let name = Mediator.resolve(MeService.ProfileService.self)?.profile?.name ?? ""
        guard let reactions = model.reactions else {
            //add reaction
            let reactions = [TimeDewReactionCellModel(reactionLabel: reactionLabel, reactionUsers: [name])]
            model.reactions = reactions
            return
        }
        
        guard let reactionIndex = reactions.firstIndex(where: {$0.reactionLabel == reactionLabel}) else {
            //add reaction
            var reactions = reactions.map({TimeDewReactionCellModel(reactionLabel: $0.reactionLabel, reactionUsers: $0.reactionUsers)})
            reactions.append(TimeDewReactionCellModel(reactionLabel: reactionLabel, reactionUsers: [name]))
            model.reactions = reactions
            return
        }
        
        if let reactionUserIndex = model.reactions![reactionIndex].reactionUsers.firstIndex(of: name) {
            //delete reaction
            addReaction = false
            let reactions = reactions.map({TimeDewReactionCellModel(reactionLabel: $0.reactionLabel, reactionUsers: $0.reactionUsers)})
            reactions[reactionIndex].reactionUsers.remove(at: reactionUserIndex)
            model.reactions = reactions
        }else{
            //add reaction
            let reactions = reactions.map({TimeDewReactionCellModel(reactionLabel: $0.reactionLabel, reactionUsers: $0.reactionUsers)})
            reactions[reactionIndex].reactionUsers.insert(name, at: 0)
            model.reactions = reactions
        }
    }
}
