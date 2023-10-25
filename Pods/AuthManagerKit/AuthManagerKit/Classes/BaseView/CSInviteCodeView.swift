//
//  CSInviteCodeView.swift
//  AuthManagerKit
//
//  Created by li on 5/11/23.
//

import Foundation
import UIKit
import SnapKit

class CSInviteCodeView: CSAuthBaseView, KeyboardObserver {
    
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
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(verfificationField.snp.top).offset(-24)
            make.leading.equalToSuperview().offset(52)
            make.trailing.equalToSuperview().offset(-52)
            make.height.equalTo(self.titleLabel.intrinsicContentSize.height)
        }
        
        detailLabel1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(self.titleLabel)
            make.bottom.equalTo(detailLabel2.snp.top).offset(-16)
        }
        
        detailLabel2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(self.titleLabel)
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
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldTitle1
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textColor = .white
        titleLabel.text = "Nice to meet you, new face. \n We need your invitation code."
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private lazy var detailLabel1: UILabel = {
        let detailLabel = UILabel()
        detailLabel.font = .regularSubheadline
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0
        detailLabel.lineBreakMode = .byWordWrapping
        let d1 = "Ruleless is currently under the public beta test, \n the access is limited to the invitation code holder."
        
        detailLabel.rz.colorfulConfer { confer in
            confer.text(d1)?.textColor(.cs_lightGrey)
        }
        return detailLabel
    }()
    
    private lazy var detailLabel2: UILabel = {
        let detailLabel = UILabel()
        detailLabel.font = .regularSubheadline
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0
        detailLabel.lineBreakMode = .byWordWrapping
        let d1 = "If you don't have an invitation code, \n join "
        let d2 =  "XXXXX on Discord."
        detailLabel.rz.colorfulConfer { confer in
            confer.text(d1)?.textColor(.cs_lightGrey)
            confer.text(d2)?.textColor(.cs_decoLightPurple).tapActionByLable("detail2").paragraphStyle?.alignment(.center)
        }
        return detailLabel
    }()
    
    
    private func signUpTapAction(_ label: UILabel, _ tapActionId: String?, _ range: NSRange) {
//        signUpHandler?()
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
