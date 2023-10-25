//
//  OtherProfileViewController.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/5/16.
//

import CSBaseView
import SnapKit
import CSAccountManager
import CSUtilities
import Foundation
import Combine
import CSNetwork
import CSCommon
import CSListView
import IGListKit
import CSMediator

class OtherProfileViewController: BaseViewController {
    
    var uid: UInt = 0
    
    private var cancellableSet = Set<AnyCancellable>()
    private var profile: ProfileModel?
    private var data: [ListDiffable] = []
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .bundleImage(named: "corner_more_light"), target: self, action: #selector(moreClick))
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        self.update()
        
    }
    
    func update() {
        Network
            .requestPublisher(UserService.user(id: uid))
            .mapModel(ProfileModel.self)
            .sink(success: { profile in
                self.update(profile: profile)
            }, failure: {[weak self] error in
                self?.emptyStyle = .noInternet(error.errorTips ?? "Network error")
            })
            .store(in: &cancellableSet)
    }
    
    private func update(profile: ProfileModel?) {
        self.profile = profile
        guard let profile = profile,
              let userModel = profile.user else {
            data = []
            adapter.performUpdates(animated: true)
            return
        }
        data.removeAll()
        let userViewModel = ProfileHeaderViewModel(name: userModel.name , online: userModel.isOnline ?? false, avatar: userModel.thumbnailUrl, subName: userModel.subName, bio: userModel.bio, labels: userModel.labels)
        data.append(userViewModel)
        
        if let action = userModel.action {
            data.append(action)
        }
        data.append("Collection" as NSString)
        let collections = profile.collections.map { model in
            
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
        adapter.performUpdates(animated: true)
    }
    
    
    @objc func moreClick() {
        
        guard (profile?.user) != nil else { return }
        
        let hideAction = CSActionSheetController.Action(title: "Hide", image: UIImage.bundleImage(named: "button_icon_solid_hide")) { [weak self] _ in
            self?.hideUser()
        }
        
        let recoverAction = CSActionSheetController.Action(title: "Recover", image: UIImage.bundleImage(named: "button_icon_solid_hide")) { [weak self] _ in
            self?.recoverUser()
        }
        let reportAction = CSActionSheetController.Action(title: "Report", image: UIImage.bundleImage(named: "button_icon_report")) { [weak self] _ in
            self?.report()
        }
        let breakConnectionsAction = CSActionSheetController.Action(title: "Break Connection", image: UIImage.bundleImage(named: "button_icon_break_connection")) { [weak self] _ in
            self?.breakConnection()
        }
        
        let actionSheeet = CSActionSheetController()
        var actions: [CSActionSheetController.Section] = [
            [
                (profile?.user?.isHidden ?? false) ? recoverAction: hideAction,
                reportAction
            ]
        ]
        if profile?.user?.relation != UserRelation.none {
            actions.insert([breakConnectionsAction], at: 0)
        }
        actionSheeet.setSections(actions)
        present(actionSheeet)
    }
    
    
    func hideUser() {
        guard let user = profile?.user else { return }
        
        Network.requestPublisher(UserService.hidden(uid: user.id))
            .mapVoid()
            .sink { [weak self] _ in
                self?.profile?.user?.isHidden = true
                HUD.showMessage("\(user.name) is hidden")
            } failure: { error in
                HUD.showError(error)
            }
            .store(in: &cancellableSet)
    }
    
    func recoverUser() {
        guard let user = profile?.user else { return }
        
        Network
            .requestPublisher(FriendService.recoverHiddenUsers(id: user.id))
            .mapVoid()
            .sink { [weak self] _ in
                self?.profile?.user?.isHidden = false
            } failure: { error in
                HUD.showError(error)
            }
            .store(in: &cancellableSet)
    }
    
    func report() {
        guard let user = profile?.user else { return }
        
        let reportVC = ReportViewController(type: .user, id: user.id.string)
        let nav = BaseNavigationController(rootViewController: reportVC)
        present(nav, animated: true)
    }
    
    func breakConnection() {
        
        let alert = CSAlertController(title: "Are you sure for breaking connection?", message: "By selecting \"Confirm\", the connection between you and your friend will break. You need to send new connection request to your friend if you want to recover this action.")
        
        let cancelAction = CSAlertController.Action(title: "Cancel", style: .red(cancel: true)) { action in
            
        }
        let confirmAction = CSAlertController.Action(title: "Confirm", style: .pure(cancel: true)) { [weak self] action in
            guard let self = self else { return }
            Network.requestPublisher(FriendService.breakConnection(uid: self.uid))
                .mapVoid()
                .sink { _ in
                    self.update()
                } failure: { error in
                    HUD.showError(error)
                }
                .store(in: &self.cancellableSet)
        }
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        self.present(alert, method: PresentTransitionMethod.centerIn)
        return
    }
}

extension OtherProfileViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is ProfileHeaderViewModel: return ProfileHeadSectionController()
        case is NSString: return TitleSectionController()
        case is ProfileButtonViewModel:
            let sectionController = ProfileButtonSectionController()
            sectionController.delegate = self
            return sectionController
        default: return TimeDewSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

extension OtherProfileViewController: ProfileButtonSectionControllerDelegate {
    func profileButtonSectionControllerDidTapButton(_ sectionController: ProfileButtonSectionController) {
        if profile?.user?.needBuildConnection == true {
            Network.requestPublisher(FriendService.invite(id: uid, type: "normal")).mapVoid().sink(success: { [weak self] _ in
                self?.update()
            }, failure: { error in
                HUD.showError(error.errorTips ?? "")
            }).store(in: &cancellableSet)
        } else if let fieldId = profile?.user?.currentFieldId {
            if let vc = Mediator.resolve(FieldService.ViewControllerService.self)?.getFieldViewController(from: fieldId) {
                Mediator.push(vc)
            }
        }
    }
    
}
