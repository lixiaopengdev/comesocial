
import CSBaseView
import SnapKit
import CSNetwork
import CSUtilities
import FileKit
import CSFileKit
import Combine
//import CSRouter
import CSCommon

class FieldListViewController: BaseViewController {
    
//    var cancellableSet: Set<AnyCancellable> = []
//    var currentView: FieldEntryView?
//    @Published var fields: [FieldModel] = []
//
//    lazy var fieldListView: LivePlayLoopsListView = {
//        let listView = LivePlayLoopsListView(frame: CGRect(x: 0, y: 0, width: Device.UI.screenWidth, height: Device.UI.screenHeight)) {
//            let fieldView = FieldEntryView(viewController: self)
//            fieldView.delegate = self
//            return fieldView
//        }
//        listView.delegate = self
//        listView.dataSource = self
//        listView.isCanLoops = false
//        return listView
//    }()
//
//    lazy var loadingView: UIView = {
//        let view = UIView()
//        let activityIndicatorView = UIActivityIndicatorView(style: .large)
//        activityIndicatorView.startAnimating()
//        activityIndicatorView.color = .cs_pureWhite
//        view.addSubview(activityIndicatorView)
//        activityIndicatorView.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }
//        return view
//    }()
//
//
//    override func viewSafeAreaInsetsDidChange() {
//        super.viewSafeAreaInsetsDidChange()
//        let entryViews = fieldListView.contentViews
//        for entryView in entryViews {
//            (entryView as? FieldEntryView)?.updateSafeAreaInset(view.safeAreaInsets)
//        }
//    }
//
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//
////        JSEngineRegister.shared.register()
////        FieldRoot.shared.registerMessageChannel()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        showVoiceBar()
//
//        let searchButton = UIButton(type: .custom)
//        searchButton.setImage(UIImage.bundleImage(named: "corner_search_light"), for: .normal)
//        searchButton.addTarget(self, action: #selector(searchClick), for: .touchUpInside)
//
//        let moreButton = UIButton(type: .custom)
//        moreButton.setImage(UIImage.bundleImage(named: "corner_more_light"), for: .normal)
//        moreButton.addTarget(self, action: #selector(moreClick), for: .touchUpInside)
//
//        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: moreButton), UIBarButtonItem(customView: searchButton)]
//
//        view.addSubview(fieldListView)
//        fieldListView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        view.addSubview(loadingView)
//        loadingView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//
//        $fields.map({ !$0.isEmpty }).weakAssign(to: \.loadingView.isHidden, on: self).store(in: &cancellableSet)
//
//        loadData()
//    }
//
//    func loadData() {
//
//        fields.removeAll()
//        DispatchQueue.main.asyncAfter(deadline: .now()) {
//            Network.request(FieldService.fields, types: FieldModel.self) {[weak self] models in
//
//                var fields = models
//                fields.removeAll()
//                //                let max = Int.random(in: 2..<4)
//                for index in 0..<5 {
//                    var field = models[0]
//                    field.name = field.name + "_\(index)"
//                    fields.append(field)
//                }
//                self?.initDatas(fields: fields)
//            }
//        }
//
//    }
//
//    func initDatas(fields: [FieldModel]) {
//        self.fields = fields
//        if fields.isEmpty { return }
//        fieldListView.currentIndex = 2
//        fieldListView.reloadData()
//    }
//
//
//    @objc func searchClick() {
//        pushToSearchFieldVC()
//    }
//
//    @objc func moreClick() {
//        showMoreViewController()
//    }
//
//}
//
//// entery View callback
//extension FieldListViewController: FieldEntryViewDelegate {
//    func entryTheFieldInfo(with view: FieldEntryView) {
//        guard let field = view.field else { return }
//        pushToFieldDetailVC(field: field)
//    }
//
//    func entryTheField(with view: FieldEntryView) {
//        guard let field = view.field else { return }
//        join(field: field)
//    }
//
//}
//
//extension FieldListViewController: LivePlayLoopsListDelegate, LivePlayLoopsListDataSource {
//
//    // datasource
//    func numberofItems(livePlayView: CSUtilities.LivePlayLoopsListView) -> Int {
//        return fields.count
//    }
//
//    // delegate
//    func checkCanScroll() -> Bool {
//        return true
//    }
//
//    func didSelect(livePlayView: CSUtilities.LivePlayLoopsListView, inView: UIView, index: Int) {
//        let entryView = inView as! FieldEntryView
//        //        entryView.update(fields[index])
//        currentView = entryView
//        print("didSelect \(index)")
//    }
//
//    func prefetch(livePlayView: CSUtilities.LivePlayLoopsListView, inView: UIView, index: Int) {
//        let entryView = inView as! FieldEntryView
//        entryView.update(fields[index])
//        print("prefetch \(index)")
//    }
//
//    // scroll
//
//
//
//
//}
//
//// Actions
//extension FieldListViewController {
//
//    func pushToFieldDetailVC(field: FieldModel) {
//        navigationController?.pushViewController(FieldDetailViewController(field: field, style: .info), animated: true)
//    }
//
//    func pushToFieldTimeDewVC(field: FieldModel) {
//        navigationController?.pushViewController(FieldDetailViewController(field: field, style: .timeDew), animated: true)
//    }
//
//    func pushToSearchFieldVC() {
//        let searchVC = FieldSearchViewController()
//        navigationController?.pushViewController(searchVC, animated: true)
//    }
//
//    func join(field: FieldModel) {
////        let assembly = FieldRoot.shared.joinField(field)
////        navigationController?.pushViewController(assembly.viewController(), animated: true)
////        Router.shared.push(Router.Field.myFieldPath())
//    }
//
//    func showMoreViewController() {
//        guard let field = currentView?.field else { return }
//        let moreViewController = MoreViewController(field: field)
//        moreViewController.moreActionCallback = {[weak self] in
//            self?.moreViewControllerCallback(field: $0, $1)
//        }
//        present(moreViewController, method: PresentTransitionMethod.lineSheet(height: 388))
//    }
//
//    func moreViewControllerCallback(field: FieldModel, _ action: MoreViewController.MoreItem) {
//        switch action {
//        case .share:
//            shareField(field)
//        case .info:
//            pushToFieldDetailVC(field: field)
//        case .dew:
//            pushToFieldTimeDewVC(field: field)
//        case .hide:
//            hideCurrentField(field)
//        case .report:
//            let reportVC = ReportViewController(type: .field, id: field.id.string)
//            let nav = BaseNavigationController(rootViewController: reportVC)
//            present(nav, animated: true)
//        }
//    }
//
//    func shareField(_ field: FieldModel) {
//        let shareVC = ShareViewController(field: field)
//        shareVC.shareActionCallback = {[weak self] in
//            self?.shareViewControllerCallback(field: $0, item: $1)
//        }
//        present(shareVC, method: PresentTransitionMethod.lineSheet(height: 216))
//    }
//
//    func shareViewControllerCallback(field: FieldModel, item: ShareViewController.ShareItem) {
//        switch item {
//        case .discord:
//            break
//        case .link:
//            break
//        case .qrCode:
//           showQRCodeViewController(field: field)
//        case .message:
//            break
//        case .airdrop:
//            break
//        }
//    }
//
//    func showQRCodeViewController(field: FieldModel) {
//        let codeVC = FieldShareQRCodeViewController()
//        codeVC.modalTransitionStyle = .crossDissolve
//        codeVC.modalPresentationStyle = .fullScreen
//        present(codeVC, animated: true)
//    }
//
//    func hideCurrentField(_ field: FieldModel) {
//        guard  field.id == currentView?.field?.id else { return }
//        currentView?.hide()
//    }
//

    

}
