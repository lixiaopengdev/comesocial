//
//  File.swift
//  AuthManagerKit
//
//  Created by li on 6/1/23.
//

import Foundation
import UIKit
import SnapKit
import CSNetwork
class CSCreatePasswordView: CSAuthBaseView, KeyboardObserver, UITextFieldDelegate {
    
    override init(frame: CGRect, paramsDict: Dictionary<String, Any>) {
        
        super.init(frame: frame, paramsDict: paramsDict)
        observer = self
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpUI() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.passwordTextField)
        self.addSubview(self.detailView1)
        self.addSubview(self.detailView2)
        self.addSubview(self.detailView3)
        self.addSubview(self.nextButton)

        passwordTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(52)
            make.trailing.equalToSuperview().inset(52)
            make.height.equalTo(48)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(132)
            make.leading.equalToSuperview().offset(52)
            make.trailing.equalToSuperview().offset(-52)
            make.height.equalTo(self.titleLabel.intrinsicContentSize.height)
        }
        
        detailView1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(107)
            make.height.equalTo(16)
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
        }
        
        detailView2.snp.makeConstraints { make in
            make.leading.equalTo(self.detailView3.snp.leading)
            make.height.equalTo(16)
            make.top.equalTo(detailView1.snp.bottom).offset(16)
        }
        
        detailView3.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(107)
            make.height.equalTo(16)
            make.top.equalTo(self.detailView2.snp.bottom).offset(16)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(180)
            make.width.height.equalTo(60)
        }
        
        
    }
    
    private lazy var passwordTextField: PasswordTextField = {
        let passwordTextField = PasswordTextField()
        passwordTextField.backgroundColor = .cs_cardColorB_40
        passwordTextField.cornerRadius = 12
        passwordTextField.font = .regularSubheadline
        passwordTextField.textColor = .lightGray
        passwordTextField.imageTintColor = .lightGray
        passwordTextField.tintColor = .white
        passwordTextField.becomeFirstResponder()
        passwordTextField.delegate = self
        return passwordTextField
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldTitle1
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textColor = .white
        titleLabel.text = "New to Ruleless? \n Create your password!"
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private lazy var detailView1: CheckDetailView = {
        let detailView = CheckDetailView()
        detailView.detailLabel.text = "6 characters minimum"
        detailView.isHidden = true
        return detailView
    }()
    
    private lazy var detailView2: CheckDetailView = {
        let detailView = CheckDetailView()
        detailView.detailLabel.text = "must contain one uppercase"
        detailView.isHidden = true
        return detailView
    }()
    
    private lazy var detailView3: CheckDetailView = {
        let detailView = CheckDetailView()
        detailView.detailLabel.text = "must contain one number"
        detailView.isHidden = true
        return detailView
    }()
    
    @objc override func nextButtonAction() {
        super.nextButtonAction()
        if self.passwordTextField.text == nil {
            return
        }
        self.resetState()
        
        
        let phoneNum = self.paramsDict["phoneNum"] as! String
        let phoneCode = self.paramsDict["phoneCode"] as! String
        
        Network.oriRequest(CSAuthService.checkPassword(regionCode: phoneCode, mobileNo: phoneNum, pw: self.passwordTextField.text!),completion: {[weak self] result in
            
            switch result {
            case let .success(data):
                let valid:Bool = (data as! Dictionary<String, Any>)["pw_valid"] as! Bool
                if valid {
                    self?.resetState()
                    self?.paramsDict["password"] = self?.passwordTextField.text
//                    self?.nextButton.setImage(UIImage.bundleForImage(named: "next_icon"), for: .normal)
                    self?.nextHandler?(.authViewStyleAgeView,self?.paramsDict ?? [:])
                } else {
                    self?.passwordTextField.borderWidth = 1
                    self?.passwordTextField.layer.borderColor = UIColor.cs_warningRed.cgColor
//                    self?.nextButton.setImage(UIImage.bundleForImage(named: "next_disable"), for: .normal)
                    let dict:Dictionary<String, Any> = (data as! Dictionary<String, Any>)["detail_error"] as! Dictionary<String, Any>
                    
                    var uppercase = false
                    if dict["uppercase"] == nil {
                        uppercase = true
                    }
                    
                    var count = false
                    if dict["count"] == nil {
                        count = true
                    } else {
                        count = false
                    }
                    
                    var digit = false
                    if dict["digit"] == nil {
                        digit = true
                    }
                    self?.detailView1.isHidden = false
                    self?.detailView2.isHidden = false
                    self?.detailView3.isHidden = false
                    
                    self?.detailView2.setState(state: uppercase)
                    self?.detailView1.setState(state: count)
                    self?.detailView3.setState(state: digit)
                }
            case let .failure(_):
                self?.resetState()
                break
            }
            })
    }
    
    func keyboardWillShow(_ notification: Notification ,_ intersectFrame:CGRect) {
        self.nextButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset((84 + intersectFrame.height))
        }
        UIView.performWithoutAnimation {
            self.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        self.nextButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(180)
        }
        UIView.performWithoutAnimation {
            self.layoutIfNeeded()        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text  = textField.text ,text.isEmpty {
            self.resetState()
        }
    }
    
    func resetState() {
        passwordTextField.layer.borderColor = UIColor.clear.cgColor
        passwordTextField.layer.borderWidth = 0
        self.detailView1.isHidden = true
        self.detailView2.isHidden = true
        self.detailView3.isHidden = true
        
    }
    
    
}


class CheckDetailView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpUI() {
        self.addSubview(self.checkButton)
        self.addSubview(detailLabel)
        
        self.checkButton.snp.makeConstraints { make in
            make.width.height.equalTo(14)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        self.detailLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.checkButton.snp.trailing).offset(7)
            make.trailing.equalTo(self.detailLabel.intrinsicContentSize.width)
        }
    }
    
    
    public lazy var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.font = .regularFootnote
        detailLabel.textAlignment = .left
        return detailLabel
    }()
    
    private lazy var checkButton: UIButton = {
        let checkButton = UIButton()
        return checkButton
    }()
    
    public func setState(state: Bool) {
        if state {
            self.checkButton.setImage(UIImage.bundleForImage(named: "mini_icon_s"), for: .normal)
            self.detailLabel.textColor = .cs_green
        } else {
            self.checkButton.setImage(UIImage.bundleForImage(named: "mini_icon_error"), for: .normal)
            self.detailLabel.textColor = .cs_warningRed
        }
    }
}

