//
//  File1.swift
//  AuthManagerKit
//
//  Created by li on 6/2/23.
//

import Foundation
import UIKit
import CSNetwork
class CSSignUpUserNameView: CSAuthBaseView , KeyboardObserver{
    override init(frame: CGRect, paramsDict: Dictionary<String, Any>) {
        super.init(frame: frame,paramsDict: paramsDict)
        observer = self
        self.setUpUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpUI(){
        self.addSubview(self.tileLabel1)
        self.addSubview(self.tileLabel2)
        self.addSubview(self.userTextField)
        self.addSubview(self.nextButton)
        
        tileLabel1.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(25)
            make.top.equalToSuperview().offset(132)
        }
        
        tileLabel2.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(25)
            make.top.equalTo(self.tileLabel1.snp.bottom).offset(10)
        }
        
        
        // Layout the buttons using SnapKit
        userTextField.snp.makeConstraints { make in
            make.top.equalTo(self.tileLabel2.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(52)
            make.trailing.equalToSuperview().offset(-52)
            make.height.equalTo(48)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(180)
            make.width.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
    }
    
    private lazy var tileLabel1: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldTitle1
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "The last and most sacred step"
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    private lazy var tileLabel2: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldTitle1
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "Sign your name"
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private lazy var userTextField:UITextField = {
        let userTextField = UITextField()
        userTextField.font = .semiBoldFont(ofSize: 18)
        userTextField.textColor = .white
        userTextField.placeholder = ("Name")
        userTextField.becomeFirstResponder()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        userTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.cs_lightGrey, NSAttributedString.Key.paragraphStyle:paragraphStyle])
        userTextField.contentHorizontalAlignment = .center
        userTextField.layer.cornerRadius = 12
        userTextField.textAlignment = .center
        userTextField.backgroundColor = .cs_cardColorB_40
        userTextField.keyboardType = .default
//        userTextField.layer.shadowColor = UIColor.cs_primaryBlack.cgColor
//        userTextField.layer.shadowOffset = CGSizeMake(0, 2)
//        userTextField.layer.shadowOpacity = 0.5
//        userTextField.layer.shadowRadius = 2
        return userTextField
    }()
    
    func keyboardWillShow(_ notification: Notification ,_ intersectFrame:CGRect) {
        self.nextButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset((84 + intersectFrame.height))
        }
        UIView.performWithoutAnimation {
            
            self.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        nextButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(180)
        }
        UIView.performWithoutAnimation {
            
            self.layoutIfNeeded()        }
    }
    
    override func nextButtonAction() {
        if userTextField.text?.count ?? 0 <= 0 {
            userTextField.layer.borderWidth = 1
            userTextField.layer.borderColor = UIColor.cs_warningRed.cgColor
        } else {
            let regionCode = self.paramsDict["phoneCode"] as! String
            let mobileNo = self.paramsDict["phoneNum"] as! String
            let password = self.paramsDict["password"] as! String
            let birthday = self.paramsDict["birthday"] as! String
            let name:String = userTextField.text!
            
            Network.request(CSAuthService.signup(regionCode: regionCode, mobileNo: mobileNo, password: password, birthday: birthday, name: name), type:AuthUserModel.self) {
                [weak self] model in
                if model.needPrivacyConfirm ?? false {
                    CSAuthManager.shared.loginFinished(userModel: model)
                    self?.nextHandler?(.authViewStyleUserAgreement, self?.paramsDict ?? .init())
                } else {
                    self?.loginCompletion?(model)
                }
            } failure: { error in
                
            }
            
        }
    }
}

