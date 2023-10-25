//
//  CSResetPNumberView.swift
//  AuthManagerKit
//
//  Created by li on 5/16/23.
//


import Foundation
import UIKit
import SnapKit

class CSResetPNumberView: CSAuthBaseView, KeyboardObserver {
    
    var countryHandler: CountryHandler?
    var phoneNumber:String?
    
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)

    
    override init(frame: CGRect, paramsDict: Dictionary<String, Any>) {
        super.init(frame: frame,paramsDict: paramsDict)
        observer = self
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
        self.addSubview(self.nextButton)
        phoneNumberTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(52)
            make.trailing.equalToSuperview().inset(52)
            make.height.equalTo(48)
            make.bottom.equalTo(self.nextButton.snp.top).offset(-146)
        }
        
        tileLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(phoneNumberTextField.snp.top).offset(-24)
            make.leading.equalToSuperview().offset(52)
            make.trailing.equalToSuperview().offset(-52)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-140)
            make.width.height.equalTo(60)
        }
    }
    
    private lazy var phoneNumberTextField : FPNTextField = {
        let phoneNumberTextField = FPNTextField()
        phoneNumberTextField.phoneTextField.delegate = self
        phoneNumberTextField.layer.cornerRadius = 12
        phoneNumberTextField.phoneTextField.placeholder = "Phone Number"
        phoneNumberTextField.phoneTextField.becomeFirstResponder()
        phoneNumberTextField.setFlag(countryCode: .US)
        phoneNumberTextField.center = self.center
        return phoneNumberTextField
    }()
    
    private lazy var tileLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldTitle1
        titleLabel.textColor = .white
        titleLabel.text = "Reset your password"
        titleLabel.textAlignment = .center
        return titleLabel
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
        super.nextButtonAction()
        nextHandler?(.authViewStyleLoginPassword,["phoneNum":phoneNumber ?? ""])
    }
    
    public func updateViewConstraints() {
        
    }
}

extension CSResetPNumberView: FPNTextFieldDelegate {
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool, beginEidting: Bool) {
        print(
            isValid,
            textField.getFormattedPhoneNumber(format: .E164) ?? "E164: nil",
            textField.getFormattedPhoneNumber(format: .International) ?? "International: nil",
            textField.getFormattedPhoneNumber(format: .National) ?? "National: nil",
            textField.getFormattedPhoneNumber(format: .RFC3966) ?? "RFC3966: nil",
            textField.getRawPhoneNumber() ?? "Raw: nil"
        )
        if beginEidting {
            inValidPhoneNum(textField: textField, isValid: isValid)
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
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-(40 + intersectFrame.height))
        }
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        self.nextButton.snp.updateConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-140)
        }
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()        }
    }
    
    func inValidPhoneNum(textField :FPNTextField, isValid : Bool) {
        if isValid {
            nextButton.isEnabled = true
            textField.layer.borderWidth = 0;
            textField.layer.borderColor = UIColor.clear.cgColor
            phoneNumber = textField.getFormattedPhoneNumber(format: .E164)
        } else {
//            nextButton.isEnabled = false
            textField.layer.borderColor = UIColor.cs_warningRed.cgColor
            textField.layer.borderWidth = 1;
        }
    }
}
