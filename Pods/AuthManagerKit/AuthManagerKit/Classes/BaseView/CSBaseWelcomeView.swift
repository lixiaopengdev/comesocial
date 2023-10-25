//
//  CSBaseWelcomeView.swift
//  AuthManagerKit
//
//  Created by li on 5/11/23.
//

import UIKit
import Foundation
import CSUtilities

//typealias SignUpHandler = () -> Void
//typealias StartHandler = () -> Void
//typealias AppleLoginHandler = () -> Void
//typealias DiscordLoginHandler = () -> Void

public class CSBaseWelcomeView: CSAuthBaseView {
    
    var signUpHandler: SignUpHandler?
    var startHandler: StartHandler?
    var appleLoginHandler: AppleLoginHandler?
    var discordLoginHandler: DiscordLoginHandler?
    override init(frame: CGRect, paramsDict: Dictionary<String, Any>) {
        super.init(frame: frame,paramsDict: paramsDict);
        createBackView();
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func createBackView() {
        
        self.addSubview(self.wLabel)
        self.addSubview(self.startButton)
//        self.addSubview(self.orLabel)
//        self.addSubview(self.rulelessLabel)
//        self.rulelessLabel.rz.tapAction(self.signUpTapAction(_:_:_:))
        self.wLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview() // 横向居中
            make.bottom.equalTo(self.startButton.snp.top).offset(-16) // 距底部 252 点
            make.height.equalTo(48) // 固定高度为 48 点
            make.width.equalTo(self.wLabel.intrinsicContentSize.width) // 宽度随文字长度自适应
        }
        // 添加约束
        startButton.snp.makeConstraints { make in
            make.width.equalTo(250)                   // 宽度为 250
            make.height.equalTo(52)                   // 高度为 52
            make.centerX.equalToSuperview()           // 横向居中
            make.bottom.equalTo(self).offset(-184)  // 距底部 184 点
        }
//        orLabel.snp.makeConstraints { make in
//            make.width.equalToSuperview()
//            make.height.equalTo(22)
//            make.centerX.equalToSuperview()
////            make.top.equalTo(self.startButton.snp.bottom).offset(10)
//            make.bottom.equalTo(self.discordButton.snp.top).offset(-10)
//        }
        
//        discordButton.snp.makeConstraints { make in
//            make.width.height.equalTo(52)
////            make.centerY.equalTo(orLabel.snp.bottom).offset(10)
//            make.trailing.equalTo(self.snp.centerX).offset(-7) // 与屏幕中心点横向对齐并向左偏移7个点
//            make.bottom.equalTo(self.rulelessLabel.snp.top).offset(-16)
//        }

//        appleButton.snp.makeConstraints { make in
//            make.width.height.equalTo(52)
//            make.centerY.equalTo(self.discordButton)
//            make.leading.equalTo(self.snp.centerX).offset(7) // 与屏幕中心点横向对齐并向右偏移7个点
//        }

//        rulelessLabel.snp.makeConstraints { make in
//            make.width.equalTo(self.rulelessLabel.intrinsicContentSize.width)
//            make.height.equalTo(20)
//            make.bottom.equalTo(self).offset(-134)
//            make.centerX.equalToSuperview()
//        }

    }
    
    private lazy var wLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 36.0) // 根据需要更改字体大小和样式
        return label
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage.bundleForImage(named: "start_back_icon"), for: .normal)
        button.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var orLabel: UILabel = {
        let label = UILabel()
        label.text = "or"
        label.textColor = .cs_lightGrey
        label.font = .regularBody
        label.textAlignment = .center
        return label
    }()
    
    private lazy var discordButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage.bundleForImage(named: "discord_back_icon"), for: .normal)
        button.addTarget(self, action: #selector(discordButtonClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var appleButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage.bundleForImage(named: "apple_back_icon"), for: .normal)
        button.addTarget(self, action: #selector(appleButtonClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var rulelessLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSubheadline
        label.rz.colorfulConfer { confer in
            confer.text("New to Ruleless? ")?.font(.regularBody).textColor(.cs_softWhite2)
            confer.text("Sign up.")?.font(.boldBody).textColor(.cs_decoLightPurple).tapActionByLable("ruleless").paragraphStyle?.alignment(.center)
        }
        return label
    }()
    @objc private func startButtonAction() {
        startHandler?()
    }
    
    private func signUpTapAction(_ label: UILabel, _ tapActionId: String?, _ range: NSRange) {
        signUpHandler?()
    }

    @objc private func discordButtonClick() {
        discordLoginHandler?()
    }
    
    @objc private func appleButtonClick() {
        appleLoginHandler?()
    }
}

