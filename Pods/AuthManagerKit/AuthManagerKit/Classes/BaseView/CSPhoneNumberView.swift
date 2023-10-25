//
//  CSPhoneNumberView.swift
//  AuthManagerKit
//
//  Created by li on 5/11/23.
//

import Foundation
import UIKit
import SnapKit
import CSNetwork
import CSUtilities

typealias TermsAndPrivacyAction = (_ url:String) -> Void
class CSPhoneNumberView: CSAuthBaseView, KeyboardObserver {
    
    var countryHandler: CountryHandler?
    var termsAndPrivacyAction:TermsAndPrivacyAction?
    var phoneNumber:String?
    var phoneNumIsValid:Bool = false
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    var isSigin:Bool = true

    override init(frame: CGRect, paramsDict: Dictionary<String, Any>) {
        super.init(frame: frame,paramsDict: paramsDict)
        observer = self
        self.isSigin = paramsDict["enter_from"] as? String == "sigin"
        self.createContainer()
        self.setUpListController()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpListController() {
        
        self.listController.setup(repository: self.getCountries())
        self.listController.didSelect = { [weak self] country in
            self?.setFlag(country: country)
        }
        
    }
    
    private func createContainer()
    {
        self.addSubview(self.tileLabel)
        self.addSubview(self.phoneNumberTextField)
        self.addSubview(self.detailLabel)
        self.addSubview(self.nextButton)
        self.detailLabel.rz.tapAction(detailLabelAction(_:_:_:))
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(52)
            make.trailing.equalToSuperview().inset(52)
            make.height.equalTo(48)
            make.top.equalTo(self.tileLabel.snp.bottom).offset(24)
        }
        
        tileLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self).offset(166)
            make.leading.equalToSuperview().offset(52)
            make.trailing.equalToSuperview().offset(-52)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
//            make.leading.equalToSuperview().offset(52)
//            make.trailing.equalToSuperview().offset(-52)
            make.width.equalTo(self.detailLabel.intrinsicContentSize.width)
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(16)
        }
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(180)
            make.width.height.equalTo(60)
        }
    }
    
    private lazy var phoneNumberTextField : FPNTextField = {
        let phoneNumberTextField = FPNTextField()
        phoneNumberTextField.phoneTextField.delegate = self
        phoneNumberTextField.layer.cornerRadius = 12
        phoneNumberTextField.phoneTextField.placeholder = "Phone Number"
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            phoneNumberTextField.phoneTextField.becomeFirstResponder()
        })
        phoneNumberTextField.setFlag(countryCode: .IE)
        phoneNumberTextField.center = self.center
        phoneNumberTextField.tintColor = .white
        return phoneNumberTextField
    }()
    
    private lazy var tileLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldTitle1
        titleLabel.textColor = .white
        if self.isSigin {
            titleLabel.text = "Enter your phone number"
        } else {
            titleLabel.text = "Sign up with your phone"
        }
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private lazy var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.font = .regularFootnote
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0
        detailLabel.lineBreakMode = .byWordWrapping
        let d1 = "By entering your phone number, you are agree to our \n"
        let d2 =  "Terms & Conditions "
        let d3 =  "and "
        let d4 =  "Privacy Policy"
        detailLabel.rz.colorfulConfer { confer in
            confer.text(d1)?.textColor(.cs_lightGrey)
            confer.text(d2)?.textColor(.cs_decoLightPurple).tapActionByLable("terms").paragraphStyle?.alignment(.center)
            confer.text(d3)?.textColor(.cs_lightGrey)
            confer.text(d4)?.textColor(.cs_decoLightPurple).tapActionByLable("privacy").paragraphStyle?.alignment(.center)
        }
        return detailLabel
    }()
    
    @objc func dismissCountries() {
        listController.dismiss(animated: true, completion: nil)
    }
    
    private func getCustomTextFieldInputAccessoryView(with items: [UIBarButtonItem]) -> UIToolbar {
        let toolbar: UIToolbar = UIToolbar()

        toolbar.barStyle = UIBarStyle.default
        toolbar.items = items
        toolbar.sizeToFit()
        return toolbar
    }
    public func getCountries() -> FPNCountryRepository {
        return phoneNumberTextField.countryRepository
    }
    
    public func setFlag(country :FPNCountry){
        phoneNumberTextField.setFlag(countryCode: country.code)
    }
    
    @objc override func nextButtonAction() {
        if self.phoneNumber == nil || !self.phoneNumIsValid {
            self.inValidPhoneNum(textField: self.phoneNumberTextField, isValid: false)
            return
        }
        
        super.nextButtonAction()
        self.paramsDict["phoneNum"] = phoneNumber
        var countryCode:String = self.phoneNumberTextField.selectedCountry!.phoneCode
        countryCode = countryCode.replacingOccurrences(of: "+", with: "")
        self.paramsDict["phoneCode"] = countryCode
        Network.oriRequest(CSAuthService.checkPhone(regionCode: countryCode, mobileNo: self.phoneNumber!), completion:{[weak self] result in
            switch result {
            case let .success(data):
                let enter:Bool = (data as! Dictionary<String, Any>)["registed"] as! Bool
                if enter {
                    self?.nextHandler?(.authViewStyleLoginPassword,self?.paramsDict ?? [:])
                } else {
                    self?.nextHandler?(.authViewStyleCreatePassword,self?.paramsDict ?? [:])
                }
            case let .failure(_):
                self?.phoneNumberTextField.layer.borderWidth = 1
                self?.phoneNumberTextField.layer.borderColor = UIColor.cs_warningRed.cgColor
                return
            }
        })
    }
    
    public func detailLabelAction(_ label:UILabel, _ tapActionId:String?,_ range:NSRange) {
        if tapActionId == "terms" {
            termsAndPrivacyAction?(Constants.Server.baseURL.appending("/api/v0/terms") as String)
        } else {
            termsAndPrivacyAction?(Constants.Server.baseURL.appending("/api/v0/privacy") as String)
        }
    }
    
}

extension CSPhoneNumberView: FPNTextFieldDelegate {
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool, beginEidting: Bool) {
        if beginEidting {
            inValidPhoneNum(textField: textField, isValid: true)
        }
    }

    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code)
    }

    func fpnDisplayCountryList() {
        let navigationController = UINavigationController(rootViewController: self.listController)

        self.listController.title = "Countries"
        self.listController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.dismissCountries))
        countryHandler?(navigationController)
    }
    
    func keyboardWillShow(_ notification: Notification ,_ intersectFrame:CGRect) {
        
        self.nextButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset((84 + intersectFrame.height))
        }
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        self.nextButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(180)
        }
        UIView.performWithoutAnimation {
            self.layoutIfNeeded()
        }
    }
    
    func inValidPhoneNum(textField :FPNTextField, isValid : Bool) {
        self.phoneNumIsValid = isValid
        if isValid {
            nextButton.setImage(UIImage.bundleForImage(named: "next_icon"), for: .normal)
            textField.layer.borderWidth = 0;
            textField.layer.borderColor = UIColor.clear.cgColor
            var formatPhone = self.formatPhoneNumber(textField.phoneTextField.text ?? "")
            phoneNumber = textField.phoneTextField.text
            self.paramsDict["formatPhoneNum"] = formatPhone
        } else {
            nextButton.setImage(UIImage.bundleForImage(named: "next_disable"), for: .normal)
            textField.layer.borderColor = UIColor.cs_warningRed.cgColor
            textField.layer.borderWidth = 1;
        }
    }
    
    func formatPhoneNumber(_ number: String) -> String {
        // Remove whitespace and other unwanted characters from the phone number
        let cleanedNumber = number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        // Check if the phone number is less than 3 digits
        guard cleanedNumber.count >= 3 else {
            return cleanedNumber
        }
        
        // Split the cleaned number into groups of 3 or less digits, separated by hyphens
        var formattedNumber = ""
        var index = cleanedNumber.startIndex
        while index < cleanedNumber.endIndex {
            let nextIndex = cleanedNumber.index(index, offsetBy: min(3, cleanedNumber.distance(from: index, to: cleanedNumber.endIndex)))
            formattedNumber += cleanedNumber[index..<nextIndex]
            if nextIndex != cleanedNumber.endIndex && formattedNumber.count < 11 {
                formattedNumber += "-"
            }
            index = nextIndex
        }
        return formattedNumber
    }

}
