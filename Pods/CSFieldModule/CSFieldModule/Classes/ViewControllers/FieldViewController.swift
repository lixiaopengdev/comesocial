//
//  FieldViewController.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/1/17.
//

import CSBaseView
import SnapKit
import SwiftyJSON
import Combine

class FieldViewController: BaseViewController {
    
    // 背景卡,效果之类的东西
    //    var backgroundLayer: BackgroundLayer {
    //        assembly.resolve()
    //    }
    // widget collection View 管理widget 布局
    var widgetlayer: WidgetLayer{
        assembly.resolve()
    }
    // 卡堆 ，自带的Im 能力
    //     var toplayer: TopLayer{
    //        assembly.resolve()
    //    }
    // 各种提示，各种动效。。。
    //     var coverlayer: CoverLayer{
    //        assembly.resolve()
    //    }
    var barHidden = false
    
    let assembly: FieldAssembly
    var cancellableSet: Set<AnyCancellable> = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_pureWhite
        label.font = .boldTitle1
        return label
    }()
    
    func setTitleHidden(_ hidden: Bool) {
        titleLabel.isHidden = hidden
    }
    
    override var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.sizeToFit()
        }
    }
    init(id: UInt) {
        self.assembly = FieldAssembly(id: id)
        super.init(nibName: nil, bundle: nil)
        assembly.viewController = self
        assembly.bootstrap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var containerView: UIView {
        return view
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = titleLabel
        self.title = "loading..."
        
        assembly
            .$status
            .receive(on: RunLoop.main)
            .sink { [weak self] status in
                switch status {
                case .loading:
                    self?.title = "loading..."
                case .succeed:
                    self?.configViews()
                case .fail(let error):
                    self?.title = ""
                    self?.emptyStyle = .error(error)
                }
            }
            .store(in: &cancellableSet)
        
    }
    
    func configViews() {
        
        title = assembly.fieldName
        let barButton = assembly.resolve(type: RightBarButton.self)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButton)
        
        //        view.addSubview(backgroundLayer)
        view.addSubview(widgetlayer)
        //        view.addSubview(toplayer)
        //        view.addSubview(coverlayer)
        
        //        backgroundLayer.snp.makeConstraints { make in
        //            make.edges.equalToSuperview()
        //        }
        widgetlayer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        //        toplayer.snp.makeConstraints { make in
        //            make.edges.equalToSuperview()
        //        }
        //        coverlayer.snp.makeConstraints { make in
        //            make.edges.equalToSuperview()
        //        }
        assembly
            .roomMessageChannel()
            .$isJoined
            .sink { [weak self ]joined in
                if joined {
                    self?.title = self?.assembly.fieldName
                } else {
                    self?.title = "connecting..."
                }
            }
            .store(in: &cancellableSet)
    }
    
    //    @objc func clearCard() {
    //        let jsonO = [
    //            "action": PA.propInit.rawValue,
    //            "version": 1,
    //            "prop": nil
    //        ] as? [String: Any?]
    //        let json = JSON(jsonO)
    //        guard let message = json.rawString(options: []) else {
    //            assertionFailure("json error")
    //            return
    //        }
    //        assembly.roomMessageChannel().askMessage(event: .propUpdate, message: message)
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        barHidden = navigationController?.isNavigationBarHidden ?? false
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(barHidden, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            FieldRoot.shared.leaveField(assembly.id)
        }
    }
    
    override var backgroundType: BackgroundType {
        return .dark
    }
    deinit {
        print("FieldViewController deinit")
    }
    
}
