//
//  File.swift
//  AuthManagerKit
//
//  Created by li on 6/5/23.
//

import Foundation
import UIKit
import CSNetwork
class CSUserAgreementView: CSAuthBaseView {
    
    override init(frame: CGRect, paramsDict: Dictionary<String, Any>) {
        super.init(frame: frame, paramsDict: paramsDict)
        self.setUpUI()
        self.fadeInLabels()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpUI(){
        self.addSubview(self.titleLabel1)
        self.addSubview(self.titleLabel2)
        self.addSubview(self.titleLabel3)
        self.addSubview(self.titleLabel4)
        self.addSubview(self.titleLabel5)
        self.addSubview(self.titleLabel6)
        self.addSubview(self.confirmButton)
        
        titleLabel1.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(18)
            make.top.equalTo(self).offset(164)
        }
        
        titleLabel2.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(18)
            make.top.equalTo(self.titleLabel1.snp.bottom).offset(65)
        }
        
        titleLabel3.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(18)
            make.top.equalTo(self.titleLabel2.snp.bottom).offset(20)
        }
        titleLabel4.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(18)
            make.top.equalTo(self.titleLabel3.snp.bottom).offset(65)
        }
        titleLabel5.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(18)
            make.top.equalTo(self.titleLabel4.snp.bottom).offset(20)
        }
        titleLabel6.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(18)
            make.top.equalTo(self.titleLabel5.snp.bottom).offset(65)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.height.equalTo(52)
            make.centerX.equalTo(self)
            make.top.equalTo(self.titleLabel6.snp.bottom).offset(97)
        }
        
    }
    
    private lazy var titleLabel1: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldHeadline
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "The journey is about to start."
        titleLabel.alpha = 0
        return titleLabel
    }()

    private lazy var titleLabel2: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldHeadline
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "Your mic, your location,"
        titleLabel.alpha = 0
        return titleLabel
    }()

    private lazy var titleLabel3: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldHeadline
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "and a bit of AI."
        titleLabel.alpha = 0
        return titleLabel
    }()

    private lazy var titleLabel4: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldTitle1
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "Stay tuned to your friends."
        titleLabel.alpha = 0
        return titleLabel
    }()
    
    private lazy var titleLabel5: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldHeadline
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "Feel the pulse, join the fun."
        titleLabel.alpha = 0
        return titleLabel
    }()
    private lazy var titleLabel6: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldTitle1
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "You in?"
        titleLabel.alpha = 0
        return titleLabel
    }()
    
        private lazy var confirmButton: UIButton = {
            let confirmButton = UIButton()
            confirmButton.setImage(UIImage.bundleForImage(named: "im_in"), for: .normal)
            confirmButton.alpha = 0
            confirmButton.addTarget(self, action: #selector(confirmButtonClick), for: .touchUpInside)
            return confirmButton
        }()
    
    @objc func confirmButtonClick() {
        Network.request(CSAuthService.privacyConfirm, type: AuthUserModel.self) {[weak self] model in
            self?.loginCompletion?(model)
        }
    }
    
    private func fadeInLabels() {
        let duration = 1.0 // 动画持续时间
        let delay = 1.0 // 每个标签的延迟时间
        var delayTime = 0.0
        
        for label in [titleLabel1, titleLabel2, titleLabel3, titleLabel4, titleLabel5, titleLabel6, confirmButton] {
            label.alpha = 0 // 初始状态为隐藏
            UIView.animate(withDuration: duration, delay: delayTime, options: .curveEaseInOut, animations: {
                label.alpha = 1 // 设置透明度为1，即淡入
            }, completion: nil)
            delayTime += delay // 增加每个标签的延迟时间
        }
    }

    // 在合适的时机调用fadeInLabels方法，如在视图控制器的viewDidLoad方法中

        
    }

