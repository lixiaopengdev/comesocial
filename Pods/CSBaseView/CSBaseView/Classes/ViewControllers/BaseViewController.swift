//
//  BaseViewController.swift
//  ComeSocial
//
//  Created by 于冬冬 on 2023/1/9.
//


import UIKit
import SnapKit
import CSUtilities

public enum BackgroundType {
    case none
    case light
    case dark
}

open class BaseViewController: UIViewController {
    
    open var backgroundType: BackgroundType {
        return .light
    }
    
    private lazy var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage.bundleImage(named: "background")
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(Device.UI.screenWidth / 390 * 230 )
        }
        return backgroundImageView
    }()
    
    private lazy var emptyView: EmptyBackgroundView = {
        let emptyView = EmptyBackgroundView()
        self.view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return emptyView
    }()
    
    public var emptyStyle: EmptyStyle? {
        didSet {
            emptyView.isHidden = emptyStyle == nil
            if let s = emptyStyle {
                emptyView.updateStyle(s)
            }
        }
    }
    
    
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        navigationItem.largeTitleDisplayMode = .never
        
        switch backgroundType {
        case .none:
            break
        case .light:
            configureWithLightBackground()
        case .dark:
            configureWithDarkBackground()
        }
        
    }
    
    public func showVoiceBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.bundleImage(named: "voice_bar"), target: self, action: #selector(toField))
    }
    
    private func configureWithLightBackground() {
        view.backgroundColor = .cs_primaryBlack
        backgroundImageView.image = UIImage.bundleImage(named: "background_light")
    }
    
    private func configureWithDarkBackground() {
        view.backgroundColor = .cs_darkBlue
        backgroundImageView.image = UIImage.bundleImage(named: "background_dark")
    }
    
    
    open override var shouldAutorotate: Bool {
        return false
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc open func toField() {
        
    }
}


public extension UIBarButtonItem {
    
    convenience init(image: UIImage?, target: Any?, action: Selector) {
        let btn = UIButton(type: .custom)
        btn.setImage(image, for: .normal)
        btn.addTarget(target, action: action, for: .touchUpInside)
        self.init(customView: btn)
    }
}
