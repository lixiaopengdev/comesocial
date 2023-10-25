//
//  RightBarButton.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/5/22.
//

import Foundation
import Combine
import CSUtilities
import SnapKit
import SwiftyJSON
//import CSRouter
import CSMediator

class RightBarButton: FieldBaseView {
    
    @Published private var folding = true
    
//    private lazy var moreButton: UIButton = {
//        return configButton(type: .more)
//    }()
//    private lazy var quitButton: UIButton = {
//        return configButton(type: .quit)
//    }()
    private lazy var friendButton: UIButton = {
        return configButton(type: .friend)
    }()
//    private lazy var propertyButton: UIButton = {
//        return configButton(type: .property)
//    }()
//    private lazy var dewButton: UIButton = {
//        return configButton(type: .dew)
//    }()
//    private lazy var closeButton: UIButton = {
//        return configButton(type: .close)
//    }()
    
    let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func initialize() {
        super.initialize()
        
        addSubview(containerView)
//        containerView.addSubview(quitButton)
        containerView.addSubview(friendButton)
//        containerView.addSubview(propertyButton)
//        containerView.addSubview(dewButton)
//        containerView.addSubview(closeButton)
//        containerView.addSubview(moreButton)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(32)
            make.height.equalTo(44)
        }
//        quitButton.snp.makeConstraints { make in
//            make.size.equalTo(CGSize(width: 32, height: 32))
//            make.centerY.equalToSuperview()
//            make.right.equalTo(0)
//        }
        friendButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 32, height: 32))
            make.centerY.equalToSuperview()
            make.right.equalTo(0)
        }
//        propertyButton.snp.makeConstraints { make in
//            make.size.equalTo(CGSize(width: 32, height: 32))
//            make.centerY.equalToSuperview()
//            make.right.equalTo(0)
//        }
//        dewButton.snp.makeConstraints { make in
//            make.size.equalTo(CGSize(width: 32, height: 32))
//            make.centerY.equalToSuperview()
//            make.right.equalTo(0)
//        }
//        closeButton.snp.makeConstraints { make in
//            make.size.equalTo(CGSize(width: 32, height: 32))
//            make.centerY.equalToSuperview()
//            make.right.equalTo(0)
//        }
//        moreButton.snp.makeConstraints { make in
//            make.size.equalTo(CGSize(width: 32, height: 32))
//            make.centerY.equalToSuperview()
//            make.right.equalTo(0)
//        }
        friendButton.alpha = 1
        $folding
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                self?.animateButtons(folding: value)
            }
            .store(in: &cancellableSet)
    }
    
    private func unfold() {
        folding = false
    }
    
    private func fold() {
        folding = true
    }
    
    func animateButtons(folding: Bool) {
//        let foldingAlpha: CGFloat = folding ? 0 : 1
//        let unfoldingAlpha: CGFloat = folding ? 1 : 0
//
//        let width = folding ? 0 : (32 + 14)
//
//        self.containerView.snp.updateConstraints { make in
//            make.width.equalTo(folding ? 32 : width * 5)
//        }
//        if !folding {
//            assembly.viewController?.setTitleHidden(true)
//        }
//
//        self.layoutIfNeeded()

//        self.quitButton.snp.updateConstraints { make in
//            make.right.equalTo(-width * 4)
//        }
//        self.friendButton.snp.updateConstraints { make in
//            make.right.equalTo(-width * 3)
//        }
//        self.propertyButton.snp.updateConstraints { make in
//            make.right.equalTo(-width * 2)
//        }
//        self.dewButton.snp.updateConstraints { make in
//            make.right.equalTo(-width)
//        }
//        UIView.animate(withDuration: 0.3) {
//            self.quitButton.alpha = foldingAlpha
//            self.friendButton.alpha = foldingAlpha
//            self.propertyButton.alpha = foldingAlpha
//            self.dewButton.alpha = foldingAlpha
//            self.closeButton.alpha = foldingAlpha
//            self.moreButton.alpha = unfoldingAlpha
//            self.layoutIfNeeded()
//        } completion: { _ in
//            if folding {
//                self.assembly.viewController?.setTitleHidden(false)
//            }
//        }
        
    }
    
    private func configButton(type: BarButtonType) -> UIButton {
        
        let button = UIButton(type: .custom)
        button.tag = type.rawValue
        button.addTarget(self, action: #selector(barButtonClick(_:)), for: .touchUpInside)
        button.setImage(UIImage.bundleImage(named: type.buttonImageName), for: .normal)
        button.alpha = 0
        return button
        
    }
    
    @objc private func barButtonClick(_ btn: UIButton) {
        guard let type = BarButtonType(rawValue: btn.tag) else { return }
        switch type {
        case .more:
            unfold()
        case .quit:
            clearCard()
        case .friend:
            
            if let vc = Mediator.resolve(FriendsService.ViewControllerService.self)?.inviteToFieldViewController() {
                assembly.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        case .property:
            break
        case .dew:
            break
        case .close:
            fold()
        }
    }
    
     func clearCard() {
        let jsonO = [
            "action": PA.propInit.rawValue,
            "version": 1,
            "prop": nil
        ] as? [String: Any?]
         let json = JSON(jsonO as Any)
        guard let message = json.rawString(options: []) else {
            assertionFailure("json error")
            return
        }
        assembly.roomMessageChannel().askMessage(event: .propUpdate, message: message)
//         HUD.showMessage("Clear All Widgets")
    }
    
}

