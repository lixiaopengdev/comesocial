//
//  CSResetPasswordView.swift
//  AuthManagerKit
//
//  Created by li on 5/16/23.
//
import Foundation
import UIKit
import SnapKit

class CSResetPasswordView: CSAuthBaseView, KeyboardObserver, UITextFieldDelegate {
    
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
            make.bottom.equalTo(self.detailView1.snp.top).offset(-16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(passwordTextField.snp.top).offset(-24)
            make.leading.equalToSuperview().offset(52)
            make.trailing.equalToSuperview().offset(-52)
            make.height.equalTo(self.titleLabel.intrinsicContentSize.height)
        }
        
        detailView1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(107)
            make.height.equalTo(16)
            make.bottom.equalTo(detailView2.snp.top).offset(-16)
        }
        
        detailView2.snp.makeConstraints { make in
            make.leading.equalTo(self.detailView3.snp.leading)
            make.height.equalTo(16)
            make.bottom.equalTo(detailView3.snp.top).offset(-16)
        }
        
        detailView3.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(107)
            make.height.equalTo(16)
            make.bottom.equalTo(self.nextButton.snp.top).offset(-50)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-108)
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
        titleLabel.text = String(format: "Reset your Password")
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private lazy var detailView1: DetailView = {
        let detailView = DetailView()
        detailView.detailLabel.text = "8 characters minimum"
        detailView.isHidden = true
        return detailView
    }()
    
    private lazy var detailView2: DetailView = {
        let detailView = DetailView()
        detailView.detailLabel.text = "must contain one uppercase"
        detailView.isHidden = true
        return detailView
    }()
    
    private lazy var detailView3: DetailView = {
        let detailView = DetailView()
        detailView.detailLabel.text = "must contain one number"
        detailView.isHidden = true
        return detailView
    }()
    
    @objc override func nextButtonAction() {
        super.nextButtonAction()
        self.detailView1.isHidden = false
        self.detailView2.isHidden = false
        self.detailView3.isHidden = false
        if self.passwordTextField.isValid() {
            self.detailView1.setState(state: true)
            self.detailView2.setState(state: true)
            self.detailView3.setState(state: true)
            self.passwordTextField.borderWidth = 0
            self.passwordTextField.layer.borderColor = UIColor.clear.cgColor
        } else {
            passwordTextField.borderWidth = 1
            passwordTextField.layer.borderColor = UIColor.cs_warningRed.cgColor
            let dict = passwordTextField.errorDetailMessages()
            var uppercase = dict["uppercase"]
            if uppercase == nil {
                uppercase = true
            }
            var count = dict["count"]
            if count == nil {
                count = true
            }
            
            var digit = dict["digit"]
            if digit == nil {
                digit = true
            }
            
            self.detailView2.setState(state: uppercase as! Bool)
            self.detailView1.setState(state: count as! Bool)
            self.detailView3.setState(state: digit as! Bool)
        }
        nextHandler?(.authViewStyleInviteCode,self.paramsDict)
    }
    
    func keyboardWillShow(_ notification: Notification ,_ intersectFrame:CGRect) {
        self.nextButton.snp.updateConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-(40 + intersectFrame.height))
        }
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        self.nextButton.snp.updateConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-108)
        }
        UIView.animate(withDuration: 0.25) {
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


class DetailView: UIView {
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

