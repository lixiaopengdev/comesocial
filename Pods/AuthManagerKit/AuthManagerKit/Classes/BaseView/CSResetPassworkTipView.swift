//
//  2.swift
//  AuthManagerKit
//
//  Created by li on 6/2/23.
//

import Foundation
import UIKit
import CSUtilities

class CSResetPasswordTipView: CSAuthBaseView {
        override init(frame: CGRect, paramsDict: Dictionary<String, Any>) {
            super.init(frame: frame,paramsDict: paramsDict)
            self.setUpUI()
        }
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        
        func setUpUI(){
            self.addSubview(self.titleLabel1)
            self.addSubview(self.titleLabel2)
            self.addSubview(self.titleLabel3)
            self.addSubview(self.copyButton)
            
            titleLabel1.snp.makeConstraints { make in
                make.width.equalTo(self)
                make.height.equalTo(25)
                make.top.equalTo(self.safeAreaLayoutGuide).offset(132)
            }
            
            titleLabel2.snp.makeConstraints { make in
                make.width.equalTo(self)
                make.height.equalTo(25)
                make.top.equalTo(self.titleLabel1.snp.bottom).offset(10)
            }
            
            titleLabel3.snp.makeConstraints { make in
                make.width.equalTo(self)
                make.height.equalTo(25)
                make.top.equalTo(self.titleLabel2.snp.bottom).offset(48)
            }
            
            copyButton.snp.makeConstraints { make in
                make.width.equalTo(200)
                make.height.equalTo(48)
                make.centerX.equalTo(self)
                make.bottom.equalToSuperview().inset(180)
            }
            
        }
        
        private lazy var titleLabel1: UILabel = {
            let titleLabel = UILabel()
            titleLabel.font = .boldTitle1
            titleLabel.textColor = .white
            titleLabel.textAlignment = .center
            titleLabel.text = "Join our Discord server to reset"
            return titleLabel
        }()
    
        private lazy var titleLabel2: UILabel = {
            let titleLabel = UILabel()
            titleLabel.font = .regularSubheadline
            titleLabel.textColor = .white
            titleLabel.textAlignment = .center
            titleLabel.text = "And discuss anything you want"
            return titleLabel
        }()
    
        private lazy var titleLabel3: UILabel = {
            let titleLabel = UILabel()
            titleLabel.font = .boldTitle1
            titleLabel.textColor = .white
            titleLabel.textAlignment = .center
            titleLabel.text = "https://discord.gg/YD22kBRp"
            return titleLabel
        }()
        
        private lazy var copyButton: UIButton = {
            let copyButton = UIButton()
            copyButton.setImage(UIImage.bundleForImage(named: "copy_email"), for: .normal)
            copyButton.addTarget(self, action: #selector(copyButtonClick), for: .touchUpInside)
            return copyButton
        }()
    
    @objc func copyButtonClick() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = self.titleLabel3.text
//        HUD.showSucceed("copied to the clipboard")
    }
        
    }

