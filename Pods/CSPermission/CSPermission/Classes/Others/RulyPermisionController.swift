//
//  RulyPermisionController.swift
//  CSPermission
//
//  Created by 于冬冬 on 2023/6/21.
//

import Foundation
import CSBaseView
import CSCommon
import CSUtilities
import CSRobotView

public class RulyPermisionController: BaseViewController {
    
    let robotView = CSRobotView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_softWhite
        label.font = .boldSubheadline
        label.text = "Hi there! It's Ruly. I need to use your mic and location to craft real-time posts for you in the background. Are you ready for me to kickstart that process?"
        label.numberOfLines = 0
        return label
    }()
    
    let textContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .cs_cardColorB_40
        view.layerCornerRadius = 20
        return view
    }()
    lazy var agreeBtn: CSGradientButton = {
        let button = CSGradientButton()
        button.setTitle("Yes, please", for: .normal)
        button.titleLabel?.font = .regularHeadline
        button.layerCornerRadius = 12
        button.addTarget(self, action: #selector(onAgress), for: .touchUpInside)
        return button
    }()
    
    lazy var laterBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Maybe later", for: .normal)
        button.titleLabel?.font = .regularHeadline
        button.layerCornerRadius = 12
        button.setBackgroundColor(color: .cs_cardColorB_40, forState: .normal)
        button.addTarget(self, action: #selector(onLater), for: .touchUpInside)
        return button
    }()
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        view.addSubview(robotView)
        view.addSubview(textContainer)
        view.addSubview(titleLabel)
        view.addSubview(agreeBtn)
        view.addSubview(laterBtn)
        robotView.say(content: nil)
        
        robotView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(25)
            make.top.equalTo(165)
        }
        
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(65)
            make.right.equalTo(-65)
            make.top.equalTo(robotView.snp.bottom)
        }
        
        textContainer.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left).offset(-14)
            make.right.equalTo(titleLabel.snp.right).offset(14)
            make.top.equalTo(titleLabel.snp.top).offset(-12)
            make.bottom.equalTo(titleLabel.snp.bottom).offset(12)

        }

        agreeBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(laterBtn.snp.top).offset(-24)
            make.size.equalTo(CGSize(width: 260, height: 52))
        }
        
        laterBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-124)
            make.size.equalTo(CGSize(width: 260, height: 52))
        }
    }
    
    var actionCallback: Action1<Bool>?
    
   public init(actionCallback: Action1<Bool>?) {
        super.init(nibName: nil, bundle: nil)
        self.actionCallback = actionCallback
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    public func showContent()
    
    @objc func onAgress() {
        self.actionCallback?(true)
    }
    
    @objc func onLater() {
        self.actionCallback?(false)
    }
}
