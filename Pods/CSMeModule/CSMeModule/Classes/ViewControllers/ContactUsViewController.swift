//
//  ContactUsViewController.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/6/5.
//

import Foundation
import CSBaseView
import CSCommon
import CSUtilities

class ContactUsViewController: BaseViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_pureWhite
        label.font = .boldTitle1
        label.text = "Join our Discord server"
        label.textAlignment = .center
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_pureWhite
        label.font = .regularSubheadline
        label.text = "And discuss anything you want!"
        label.textAlignment = .center
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_pureWhite
        label.font = .boldTitle1
        label.text = "https://discord.gg/YD22kBRp"
        label.textAlignment = .center
        return label
    }()
    
    lazy var copyBtn: CSGradientButton = {
        let button = CSGradientButton()
        button.setTitle("Copy Link", for: .normal)
        button.titleLabel?.font = .boldBody
        button.layerCornerRadius = 12
        button.addTarget(self, action: #selector(copyEmail), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(emailLabel)
        view.addSubview(copyBtn)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(subtitleLabel.snp.bottom).offset(50)
        }
        copyBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-180)
            make.size.equalTo(CGSize(width: 200, height: 48))
        }
    }
    
    @objc func copyEmail() {
        UIPasteboard.general.string = emailLabel.text
        HUD.showMessage("copied to the clipboard")
    }
}
