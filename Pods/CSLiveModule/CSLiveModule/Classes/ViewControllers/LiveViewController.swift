
import CSBaseView
import SnapKit
import CSAccountManager
import CSSpyExpert
import CSNetwork
import CSUtilities
import CSRobotView
//import CSRouter
import CSCommon
import Combine
import IGListSwiftKit
import IGListKit
import CSListView
import UIKit
import CSPermission
import CSMediator


class LiveViewController: BaseViewController  {
    @objc func logoutClick() {
        AccountManager.shared.logout()
    }
    
    //MARK: - UI Compents
    var robotView: CSRobotView?
    var loadingLabel: UILabel?
    var failureView: UIView?
    var goastButton: UIButton?
    lazy var adapter: ListAdapter = { return ListAdapter(updater: ListAdapterUpdater(), viewController: self) }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    
    
    var timer: Timer? = nil
    var isRobotViewInited = false
    var tempReqesutSessionId: String = "xxx"
    
    @Published private(set) var permissionAvaliable: Bool = false
    var cancellableSet: Set<AnyCancellable> = []
    

    var viewModel:TimeDewListViewRepresentable = TimeDewListViewModel()
    var robotViewModel:RobotViewRepresentable = RobotViewModel()
    var loadDataSubject = PassthroughSubject<Void,Never>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(screenLocked), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(screenUnlocked), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        initNavagation()
        initLifeDewView()
        showRobotView()
        
        setupBindings()
    }
    

    // 监听屏幕锁定事件
    @objc func screenLocked() { stopStateLoop() }
    // 监听屏幕解锁事件
    @objc func screenUnlocked() { startStateLoop() }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        updateLifeTimeDewDatas()
        startStateLoop()
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        stopStateLoop()
    }
    
    @objc override func toField() {
        jumpToField(fieldID: 0)
    }
}

// MARK: - ListAdapter Data Source
extension LiveViewController : ListAdapterDataSource{
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.datas
    }

    func listAdapter(
        _ listAdapter: ListAdapter,
        sectionControllerFor object: Any
        ) -> ListSectionController {
            
        let model = object as! TimeDewViewModel
        if model.type == "invite" {
            let controller = TimeDewEventController()
            return controller
        }else {
            let controller = TimeDewSectionController()
            controller.timeDewDelegate = self
            return controller
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? { return nil }
}



//MARK: - UI Handles
extension LiveViewController {
    fileprivate func setupBindings() {
        //权限控制监听
        PermissionManager.shared.$timeDewAuthorized.sink { [weak self] isTimeDewAuthorized in
            if isTimeDewAuthorized {
                let recordingPermission = SpyExpert.shared.checkRecordingPermission()
                let locationPermission = SpyExpert.shared.checkLocationPermission()
                
                if recordingPermission > 0 || locationPermission > 0 {
                    SpyExpert.shared.startTask()
                }else if recordingPermission == 0 && locationPermission == 0 {
                    print("do nothing")
                }else {
                    self?.showLeaveGoastAlert(message: "You need to enable microphone or location for Ruly to generate posts.")
                }
            }else{
                SpyExpert.shared.stopTask()
            }
        }.store(in: &cancellableSet)
        
        //权限控制数据拉取
        AccountManager.shared.$isLogin.removeDuplicates().sink { [weak self] login in
            if login {
                self?.startStateLoop()
            } else {
                self?.stopStateLoop()
            }
        }.store(in: &cancellableSet)
        
        $permissionAvaliable.removeDuplicates().sink { value in
            guard value else { return }
            SpyExpert.shared.startTask()
        }.store(in: &cancellableSet)
            
    
        SpyExpert.shared.$pushData.removeDuplicates().sink { [weak self] isPushData in
            guard let self = self else { return }
            self.goastButton?.isSelected = !isPushData
            guard self.loadingLabel == nil else { return }
            let robotState = isPushData ? RobotMode.NormalMode : RobotMode.GoastMode
            self.robotView?.setScene(state: robotState)
        }.store(in: &cancellableSet)
        

        
        viewModel.attachViewEventListener(loadData: loadDataSubject.eraseToAnyPublisher())
        viewModel.reloadList.sink(
            receiveCompletion: { completion in
                print("viewModel.reloadList receiveCompletion")
            },
            receiveValue:{ [weak self] value in
                guard let self = self else {return}
                if value.isSuccess && self.isRobotViewInited {
                    self.adapter.performUpdates(animated: true)
                    return
                }
                
                if value.isSuccess && !self.isRobotViewInited {
                    self.robotViewModel.stateChange(state: .layouting)
                    return
                }
                
                self.viewModel.attachViewEventListener(loadData: self.loadDataSubject.eraseToAnyPublisher())
                guard self.isRobotViewInited == false else { return }
                self.loadFailureView()
                self.robotViewModel.stateChange(state: .hide)
            }
        )
        .store(in: &cancellableSet)
        
        viewModel.cellUpdate.sink { (row: Int, model: TimeDewViewModel) in
            guard let sectionController = self.adapter.sectionController(forSection: row) else {return}
            guard let timeDewSectionController = sectionController as? TimeDewSectionController else {return}
            timeDewSectionController.didUpdate(to: model)
        }.store(in: &cancellableSet)
        
        
        robotViewModel.stateChange.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .layouting:
                self?.removeFailureView()
                self?.showRobotView()
                self?.normalizeRobotView()
                break
            case .loaded:
                self?.robotView?.setState(state: .state_normal)
                self?.robotView?.setScene(state: .InitMode)
                self?.adapter.performUpdates(animated: true)
                break
            case .loading:
                self?.removeFailureView()
                self?.showRobotView()
                break
            case .hide:
                self?.hideRobotView()
                break
            }
        }.store(in: &cancellableSet)

    }
    

    
    fileprivate func removeFailureView() {
        guard let failureView = failureView else{
            return
        }
        failureView.removeFromSuperview()
        self.failureView = nil
    }
    
    fileprivate func loadFailureView() {
        guard let url = Bundle(for: LiveViewController.self).url(forResource: "CSLiveModule", withExtension: "bundle") else {
            return
        }
        guard failureView == nil else{
            return
        }
        
        
        let failureView = UIView()
        view.addSubview(failureView)
        self.failureView = failureView
        
        failureView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(70)
            make.right.equalToSuperview().offset(-70)
            make.centerY.equalToSuperview().offset(-50)
        }
        
        
        let failureImageView = UIImageView()
        failureView.addSubview(failureImageView)
        
        failureImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(136)
            make.centerX.equalToSuperview()
        }
        failureImageView.image = UIImage(named: "No Internet", in: Bundle(url: url), compatibleWith: nil)
        
        
        let failureLabel = UILabel()
        failureView.addSubview(failureLabel)
        
        failureLabel.snp.makeConstraints { make in
            make.top.equalTo(failureImageView.snp.bottom).offset(16)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        failureLabel.textColor = .white
        failureLabel.font = UIFont.systemFont(ofSize: 14)
        failureLabel.numberOfLines = 0
        failureLabel.lineBreakMode = .byWordWrapping
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05
        failureLabel.textAlignment = .center
        failureLabel.attributedText = NSMutableAttributedString(string: "Oops! It seems like your connection was lost. Please check your internet connection and try again.", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        
        let tryAgainButton = UIButton()
        failureView.addSubview(tryAgainButton)
        
        tryAgainButton.snp.makeConstraints { make in
            make.top.equalTo(failureLabel.snp.bottom).offset(40)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        tryAgainButton.layer.backgroundColor = UIColor(red: 0.24, green: 0.227, blue: 0.4, alpha: 0.2).cgColor
        tryAgainButton.layer.cornerRadius = 10
        tryAgainButton.setTitle("Try Again", for: .normal)
        tryAgainButton.addTarget(self, action: #selector(tryAgainConnect), for: .touchUpInside)
    }
    
    fileprivate func initNavagation() {
        guard let url = Bundle(for: LiveViewController.self).url(forResource: "CSLiveModule", withExtension: "bundle"),
              let localBundle = Bundle(url: url) else {
            return
        }
        showVoiceBar()
        let someButton = UIButton()
        goastButton = someButton
        someButton.setImage(UIImage(named: "Corner Button 2", in: localBundle, compatibleWith: nil), for: .normal)
        someButton.setImage(UIImage(named: "Corner Button", in: localBundle, compatibleWith: nil), for: .selected)
        someButton.addTarget(self, action: #selector(ghostModeButtonClick), for: .touchUpInside)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: someButton)]
    }
    
    fileprivate func initLifeDewView() {
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(64)
        }
    }
    
    fileprivate func showRobotView() {
        if robotView == nil {
            robotView = CSRobotView()
            robotView!.setState(state: .state_try_connect)
            robotView!.say(content: nil)
            view.addSubview(robotView!)
            
            robotView!.snp.makeConstraints { make in
                make.left.equalToSuperview().offset((Int(view.frame.size.width) >> 1) - 50)
                make.top.equalToSuperview().offset((Int(view.frame.size.height) >> 1) - 100)
            }
        }
 
        
        
        
        if loadingLabel == nil {
            let loadingLabel = UILabel()
            self.loadingLabel = loadingLabel
            view.addSubview(loadingLabel)
            loadingLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.643, alpha: 1)
            loadingLabel.font = UIFont.systemFont(ofSize: 16)
            let loadingLabelParagraphStyle = NSMutableParagraphStyle()
            loadingLabelParagraphStyle.lineHeightMultiple = 1.01
            loadingLabel.attributedText = NSMutableAttributedString(string: "Loading...", attributes: [NSAttributedString.Key.paragraphStyle: loadingLabelParagraphStyle])
            loadingLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(robotView!.snp.bottom).offset(12)
            }
        }
        
        robotView!.isHidden = false
        loadingLabel?.isHidden = false
    }
    
    fileprivate func hideRobotView() {
        robotView!.isHidden = true
        loadingLabel?.isHidden = true
    }
    
    fileprivate func normalizeRobotView() {
        loadingLabel?.removeFromSuperview()
        loadingLabel = nil
        isRobotViewInited = true
        
        self.robotView?.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-20)
            make.left.equalToSuperview().offset(14)
            make.right.equalToSuperview().offset(-14)
        }
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let self = self else {
                return
            }
            self.view.layoutIfNeeded()
        }) { [weak self] _ in
            self?.robotViewModel.stateChange(state: .loaded)
        }
    }
}





//MARK: - Network Datas
extension LiveViewController {
    func updateLifeTimeDewDatas() {
        guard AccountManager.shared.isLogin else {
            return
        }
        loadDataSubject.send()
    }

    //开始网络请求的轮询
    func startStateLoop() {
        guard AccountManager.shared.isLogin else {
            return
        }
        
        guard timer == nil else {
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.updateLifeTimeDewDatas()
        }
    }
    
    func stopStateLoop() {
        guard let timer = timer else {
            return
        }
        timer.invalidate()
        self.timer = nil

    }
}





// MARK: - TimeDew SectionDelegate
extension LiveViewController : TimeDewSectionDelegate {
    func onReactionClick(model: CSListView.TimeDewViewModel, reactionLabel: String) {
        let name = Mediator.resolve(MeService.ProfileService.self)?.profile?.name ?? ""
        viewModel.deleteReaction(id: model.id, label: reactionLabel, onwer: name)
    }
    
    func onCellClick(model: CSListView.TimeDewViewModel) {
        showMoreViewController(item: model)
    }
    
    func onAvatarImageClick(model: CSListView.TimeDewViewModel) {
        guard let ownerID = model.onwerID else { return }
        guard let ownerIDII = UInt(ownerID) else { return }
        
//        Router.shared.push(Router.Me.profilePath(uid: ownerIDII))
        Mediator.push(Mediator.resolve(MeService.ViewControllerService.self)?.profileViewController(uid: ownerIDII))
    }
    
    func onImageContentClick(model: CSListView.TimeDewViewModel, image: UIImage) {
        showImageContent(image: image)
    }
}






//MARK: - TimeDew View Controlelr Handles
extension LiveViewController {
    @objc
    func tryAgainConnect() {
        robotViewModel.stateChange(state: .loading)
        updateLifeTimeDewDatas()
    }
    
    @objc
    fileprivate func ghostModeButtonClick(button: UIButton) {
        if SpyExpert.shared.pushData {
            SpyExpert.shared.stopTask()
        }else{
            if SpyExpert.shared.checkRecordingPermission() > 0 || SpyExpert.shared.checkLocationPermission() > 0 {
                SpyExpert.shared.startTask()
            }else {
                showLeaveGoastAlert(message: "You need to enable microphone or location for Ruly to exit Ghost Mode and generate posts.")
            }
        }
    }
    
    fileprivate func showLeaveGoastAlert(message: String) {
        let alert = CSAlertController(title: "Permission Required", message: message)
        let logoutAction = CSAlertController.Action(title: "Enable", style: .red(cancel: true)) { action in
            
            if SpyExpert.shared.checkRecordingPermission() == 0 || SpyExpert.shared.checkLocationPermission() == 0 {
                PremissionManager.shared.requestPremissions(needPremissions: [.Microphone ]) { [weak self] result in
                    if result {
                        self?.permissionAvaliable = true
                    }
                    PremissionManager.shared.requestPremissions(needPremissions: [.Location ]) { [weak self] result in
                        if result {
                            self?.permissionAvaliable = true
                        }
                    }
                }
            }else{
                if let settingURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingURL)
                }
            }
        }
        let cancelAction = CSAlertController.Action(title: "Cancel", style: .pure(cancel: true))
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)

        self.present(alert, method: PresentTransitionMethod.centerIn)
    }
    
    fileprivate func jumpToField(fieldID: UInt) {
        if fieldID == 0 {
//            Mediator.resolve(FieldService.ViewControllerService.self)?.myFieldViewController()
            if let vc = Mediator.resolve(FieldService.ViewControllerService.self)?.myFieldViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            
            if let vc = Mediator.resolve(FieldService.ViewControllerService.self)?.getFieldViewController(from: fieldID) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
            Mediator.resolve(LiveService.TimeDewService.self)?.jumpFieldTimeDew(fieldId: fieldID)
//            Router.shared.open(Router.Live.jumpFieldTimeDewPath(fieldId: fieldID))
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
        var isSaveTimeDew:String? = nil
        let isOwnerTimeDew:Bool = {
            if let onwerID = item.onwerID,
               let onwerIDInt = Int(onwerID),
               onwerIDInt == AccountManager.shared.id {
                return true
            }
            return false
        }()
        
        if isOwnerTimeDew {
            isSaveTimeDew = {
                guard let isSaved = item.isSave else {
                    return "false"
                }
                if isSaved {
                    return "true"
                }else{
                    return "false"
                }
            }()
        }
        
        
        tempReqesutSessionId = UUID().uuidString
        
        
        if let moreViewController = Mediator.resolve(LiveService.ViewControllerService.self)?.moreFunction(requestSessionId: tempReqesutSessionId, timeDewId: item.id, timeDewType: item.type!, isSaveTimeDew: isSaveTimeDew) {
            NotificationCenter.default.removeObserver(self)
            NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("TimeDewFunctionNotification"), object: nil)
            if isOwnerTimeDew {
                self.present(moreViewController, method: PresentTransitionMethod.lineSheet(height: 408, timeInterval: 0.2))
            }else{
                self.present(moreViewController, method: PresentTransitionMethod.lineSheet(height: 330, timeInterval: 0.2))
            }
        }
    }
    
    
    @objc func handleNotification(_ notification: Notification) {
        guard notification.name == Notification.Name(rawValue: "TimeDewFunctionNotification") else { return }
        guard let userInfo = notification.userInfo else { return }
        guard let requsestSessionID = userInfo["requsestSessionID"] as? String,
              tempReqesutSessionId == requsestSessionID else { return }
        guard let handleCode = userInfo["handleCode"] as? UInt else {return}
        
        let name = Mediator.resolve(MeService.ProfileService.self)?.profile?.name ?? ""
        switch handleCode {
        case  0:
            guard let timeDewId = userInfo["timeDewId"] as? UInt else { return }
            guard let toSave = userInfo["toSave"] as? Bool else { return }
            if toSave {
                viewModel.saveTimeDew(id: timeDewId)
            }else{
                viewModel.cancleSaveTimeDew(id: timeDewId)
            }
            break
        case 1 :
            guard let timeDewId = userInfo["timeDewId"] as? UInt else { return }
            guard let reactionLabel = userInfo["reactionLabel"] as? String else { return }
            guard let model = viewModel.findModelById(id: timeDewId) else {return}
            if viewModel.hasReaction(id: model.id, label: reactionLabel, onwer: name) {
                viewModel.deleteReaction(id: model.id, label: reactionLabel, onwer: name)
            }else{
                viewModel.addReaction(id: model.id, label: reactionLabel, onwer: name)
            }
        
            break
        case 2:
            guard let timeDewId = userInfo["timeDewId"] as? UInt else { return }
            guard let model = viewModel.findModelById(id: timeDewId) else {return}
            guard let fieldID = model.fieldID else { return }
            
            jumpToField(fieldID: fieldID)
            break
        case 3:

            guard let timeDewId = userInfo["timeDewId"] as? UInt else { return }
            guard let model = viewModel.findModelById(id: timeDewId) else {return}
            guard let content = model.content,
                  let title = model.title else { return }

//            Mediator.resolve(LiveService.ViewControllerService.self)?.shareTimeDewViewController(titleText: title, contentText: content, photoImageURL: model.icon, contentImageURL: model.imageContent)
            if let shareViewController = Mediator.resolve(LiveService.ViewControllerService.self)?.shareTimeDewViewController(titleText: title, contentText: content, photoImageURL: model.icon, contentImageURL: model.imageContent) {
                self.navigationController?.pushViewController(shareViewController, animated: true)
            }
            break
        case 4:

            guard let timeDewId = userInfo["timeDewId"] as? UInt else { return }
            guard let model = viewModel.findModelById(id: timeDewId) else {return}
            guard let fieldID = model.fieldID else {return}
            
            let reportVC = ReportViewController(type: .timeDew, id: String(fieldID))
            let nav = BaseNavigationController(rootViewController: reportVC)
            self.present(nav, animated: true)
            break
        case 5:

            guard let timeDewId = userInfo["timeDewId"] as? UInt else { return }
            guard let model = viewModel.findModelById(id: timeDewId) else {return}
            guard let fieldOnwerID = model.onwerID else {return}
            guard let fieldOnwerIDInt = UInt(fieldOnwerID) else {return}
            
            if fieldOnwerIDInt != AccountManager.shared.id {
                Mediator.resolve(LiveService.TimeDewService.self)?.jumpFieldTimeDew(fieldId: fieldOnwerIDInt)
//                Router.shared.open(Router.Live.jumpFieldTimeDewPath(fieldId: fieldOnwerIDInt))
//                self.showToast(message: "An invitation has been sent to the user!")
            }
            break
        default:
            break
        }
    }
    
    
}
