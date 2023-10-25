//
//  CSVerificationCodeView.swift
//  AuthManagerKit
//
//  Created by li on 5/16/23.
//

import Foundation
import UIKit
import SnapKit

typealias SignInPasswordHandler = (_ authViewStyle:AuthViewStyle, _ paramsDict:Dictionary<String, Any>) -> Void

class CSVerificationCodeView: CSAuthBaseView, KeyboardObserver {
    
    var passwordHandler: SignInPasswordHandler?
    override init(frame: CGRect, paramsDict: Dictionary<String, Any>) {
        
        super.init(frame: frame,paramsDict: paramsDict)
        observer = self
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpUI() {
        self.addSubview(self.tileLabel)
        self.addSubview(self.verfificationField)
        self.addSubview(self.detailLabel1)
        self.addSubview(self.detailLabel2)
        self.addSubview(self.nextButton)
        self.detailLabel2.rz.tapAction(self.signUpTapAction(_:_:_:))

        verfificationField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(52)
            make.trailing.equalToSuperview().inset(52)
            make.height.equalTo(48)
            make.bottom.equalTo(self.detailLabel1.snp.top).offset(-16)
        }
        
        tileLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(verfificationField.snp.top).offset(-24)
            make.leading.equalToSuperview().offset(52)
            make.trailing.equalToSuperview().offset(-52)
        }
        
        detailLabel1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(self.tileLabel)
            make.bottom.equalTo(detailLabel2.snp.top).offset(-16)
        }
        
        detailLabel2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(self.detailLabel2.intrinsicContentSize.width)
            make.bottom.equalTo(nextButton.snp.top).offset(-82)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-108)
            make.width.height.equalTo(60)
        }
        
        
    }
    
    private lazy var verfificationField: PFCodeInputView = {
        let verfificationField = PFCodeInputView()
        verfificationField.secureTextEntry = true
        verfificationField.backgroundColor = .cs_cardColorB_40
        verfificationField.layer.cornerRadius = 12
        verfificationField.becomeFirstResponder()
        verfificationField.dotColor = .cs_lightGrey
        verfificationField.completion = {[weak verfificationField] text in
            print(text)
            let _ = verfificationField?.resignFirstResponder()
        }
        return verfificationField
    }()
    
    private lazy var tileLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldTitle1
        titleLabel.textColor = .white
        titleLabel.text = "We sent you a text message"
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private lazy var detailLabel1: UILabel = {
        let detailLabel = UILabel()
        detailLabel.font = .regularFootnote
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0
        detailLabel.lineBreakMode = .byWordWrapping
        let d1 = "Don't receive it? "
        let d2 =  "Resend it."
        
        detailLabel.rz.colorfulConfer { confer in
            confer.text(d1)?.textColor(.cs_lightGrey)
            confer.text(d2)?.textColor(.cs_decoLightPurple).tapActionByLable("rensend").paragraphStyle?.alignment(.center)
        }
        return detailLabel
    }()
    
    private lazy var detailLabel2: UILabel = {
        let detailLabel = UILabel()
        detailLabel.font = .regularFootnote
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0
        detailLabel.lineBreakMode = .byWordWrapping
        let d1 = "Can't receive it? "
        let d2 =  "Sign in with password."
        detailLabel.rz.colorfulConfer { confer in
            confer.text(d1)?.textColor(.cs_lightGrey)
            confer.text(d2)?.textColor(.cs_decoLightPurple).tapActionByLable("password").paragraphStyle?.alignment(.center)
        }
        return detailLabel
    }()
    
    private func signUpTapAction(_ label: UILabel, _ tapActionId: String?, _ range: NSRange) {
        if tapActionId == "password" {
            passwordHandler!(.authViewStyleLoginPassword,self.paramsDict)
        } else if tapActionId == "rensend" {
            
        }
    }
    
    @objc override func nextButtonAction() {
        super.nextButtonAction()
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
}

