//
//  CSResetSuccessView.swift
//  AuthManagerKit
//
//  Created by li on 5/16/23.
//

import Foundation
class CSResetSuccessView: CSAuthBaseView {
    override init(frame: CGRect, paramsDict: Dictionary<String, Any>) {
        
        super.init(frame: frame, paramsDict: paramsDict)
        self.setUpUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpUI() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.detailLabel)
        self.addSubview(self.loginButton)
        self.addSubview(self.imageView)
        
        self.titleLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide).offset(136)
        }
        self.detailLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
        }
        self.loginButton.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.height.equalTo(52)
            make.top.equalTo(self.imageView.snp.bottom).offset(70)
            make.centerX.equalToSuperview()
        }
        self.imageView.snp.makeConstraints { make in
            make.width.height.equalTo(198)
            make.top.equalTo(self.detailLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
    }
    
    private lazy var titleLabel: UILabel = {
       let titleLabel = UILabel()
        titleLabel.font = .boldTitle1
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "Password Change!"
        
        return titleLabel
    }()
    
    private lazy var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.font = .regularFootnote
        detailLabel.textColor = .cs_decoLightPurple
        detailLabel.textAlignment = .center
        detailLabel.text = "Your password has been changed successfully!"
        return detailLabel
    }()
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.bundleForImage(named: "success_lock")
        return imageView
    }()
    
    private lazy var loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setImage(UIImage.bundleForImage(named: "login_icon"), for: .normal)
        loginButton.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        return loginButton
        
    }()
    
    @objc func buttonClick() {
        
    }
}
