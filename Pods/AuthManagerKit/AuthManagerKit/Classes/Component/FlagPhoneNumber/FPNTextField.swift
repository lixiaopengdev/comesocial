//
//  FlagPhoneNumberTextField.swift
//  FlagPhoneNumber
//
//  Created by Aurélien Grifasi on 06/08/2017.
//  Copyright (c) 2017 Aurélien Grifasi. All rights reserved.
//

import UIKit

open class FPNTextField: UIView {

	/// The size of the flag button
    var flagButtonSize: CGSize = CGSize(width: 24, height: 46)
    var beginEditing = false
	/// The size of the leftView
	private var leftViewSize: CGSize {
        let width = 34 + flagButtonSize.width + getWidth(text: phoneCodeLabel.text ?? "")
		let height = bounds.height

		return CGSize(width: width, height: height)
	}

	private var phoneCodeLabel: UILabel = UILabel()

	private lazy var phoneUtil: NBPhoneNumberUtil = NBPhoneNumberUtil()
	private var nbPhoneNumber: NBPhoneNumber?
	private var formatter: NBAsYouTypeFormatter?

	open var flagImageView: UIImageView = UIImageView()
    open var phoneTextField: UITextField = UITextField()
    open var leftView: UIButton = UIButton()
	open var countryRepository = FPNCountryRepository()

	open var selectedCountry: FPNCountry? {
		didSet {
			updateUI()
		}
	}

	/// Input Accessory View for the texfield
	@objc open var textFieldInputAccessoryView: UIView?

	open lazy var pickerView: FPNCountryPicker = FPNCountryPicker()

	@objc public enum FPNDisplayMode: Int {
		case picker
		case list
	}

	@objc open var displayMode: FPNDisplayMode = .list

	init() {
		super.init(frame: .zero)

		setup()
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)

		setup()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		setup()
	}

	private func setup() {
        self.clipsToBounds = true
        self.backgroundColor = .cs_cardColorB_40
		setupFlagImageView()
		setupPhoneCodeLabel()
        setUpPhoneTextField()
		setupLeftView()
		
		if let regionCode = Locale.current.regionCode, let countryCode = FPNCountryCode(rawValue: regionCode) {
			setFlag(countryCode: countryCode)
		} else {
			setFlag(countryCode: FPNCountryCode.FR)
		}
	}

    private func setupFlagImageView() {
		flagImageView.contentMode = .scaleAspectFit
		flagImageView.accessibilityLabel = "flagImageView"
		flagImageView.translatesAutoresizingMaskIntoConstraints = false
	}

	private func setupPhoneCodeLabel() {
        phoneCodeLabel.font = .regularHeadline
        phoneCodeLabel.textColor = .white
	}

    private func setupLeftView() {
        self.addSubview(leftView)
        self.addSubview(phoneTextField)
        leftView.backgroundColor = .cs_cardColorB_40
        leftView.addSubview(flagImageView)
        leftView.addSubview(phoneCodeLabel)
        
        leftView.addTarget(self, action: #selector(displayCountries), for: .touchUpInside)
        leftView.snp.makeConstraints { make in
            make.width.equalTo(leftViewSize.width)
            make.height.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        flagImageView.snp.makeConstraints { make in
            make.width.equalTo(flagButtonSize.width)
            make.height.equalTo(flagButtonSize.height)
            make.centerY.equalTo(leftView)
            make.leading.equalTo(leftView).offset(14)
        }
        
        phoneCodeLabel.snp.makeConstraints { make in
            make.leading.equalTo(flagImageView.snp.trailing).offset(8)
            make.trailing.equalTo(leftView).offset(-12)
            make.top.equalTo(leftView)
            make.bottom.equalTo(leftView)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.leading.equalTo(leftView.snp.trailing).offset(24)
            make.trailing.equalToSuperview()
            make.height.equalToSuperview()
            make.top.equalToSuperview()
        }
        
    }
    private func setUpPhoneTextField() {
        phoneTextField.keyboardType = .numberPad
        phoneTextField.autocorrectionType = .no
        phoneTextField.textColor = .white
        let placeholderText = "Phone Number"
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.cs_lightGrey, NSAttributedString.Key.font:UIFont.regularHeadline]
        phoneTextField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        phoneTextField.addTarget(self, action: #selector(beginEdit), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(displayNumberKeyBoard), for: .touchDown)
    }
    
    @objc func beginEdit() {
        beginEditing = true
        didEditText()
    }
    
    open override func updateConstraints() {
        super.updateConstraints()
        leftView.snp.updateConstraints { make in
            make.width.equalTo(leftViewSize.width)
        }
    }

	@objc private func displayNumberKeyBoard() {
		switch displayMode {
		case .picker:
			tintColor = .gray
//			inputView = nil
//			inputAccessoryView = textFieldInputAccessoryView
			reloadInputViews()
		default:
			break
		}
	}

	@objc private func displayCountries() {
        return
		switch displayMode {
		case .picker:
			pickerView.setup(repository: countryRepository)

			tintColor = .clear
//			inputView = pickerView
//			inputAccessoryView = getToolBar(with: getCountryListBarButtonItems())
			reloadInputViews()
			becomeFirstResponder()

			pickerView.didSelect = { [weak self] country in
				self?.fpnDidSelect(country: country)
			}

			if let selectedCountry = selectedCountry {
				pickerView.setCountry(selectedCountry.code)
			} else if let regionCode = Locale.current.regionCode, let countryCode = FPNCountryCode(rawValue: regionCode) {
				pickerView.setCountry(countryCode)
			} else if let firstCountry = countryRepository.countries.first {
				pickerView.setCountry(firstCountry.code)
			}
		case .list:
            (phoneTextField.delegate as? FPNTextFieldDelegate)?.fpnDisplayCountryList()
		}
	}

	@objc private func dismissCountries() {
		resignFirstResponder()
//		inputView = nil
//		inputAccessoryView = nil
		reloadInputViews()
	}

	private func fpnDidSelect(country: FPNCountry) {
        (phoneTextField.delegate as? FPNTextFieldDelegate)?.fpnDidSelectCountry(name: country.name, dialCode: country.phoneCode, code: country.code.rawValue)
		selectedCountry = country
	}

	// - Public

	/// Get the current formatted phone number
	open func getFormattedPhoneNumber(format: FPNFormat) -> String? {
		return try? phoneUtil.format(nbPhoneNumber, numberFormat: convert(format: format))
	}

	/// For Objective-C, Get the current formatted phone number
	@objc open func getFormattedPhoneNumber(format: Int) -> String? {
		if let formatCase = FPNFormat(rawValue: format) {
			return try? phoneUtil.format(nbPhoneNumber, numberFormat: convert(format: formatCase))
		}
		return nil
	}

	/// Get the current raw phone number
	@objc open func getRawPhoneNumber() -> String? {
		let phoneNumber = getFormattedPhoneNumber(format: .E164)
		var nationalNumber: NSString?

		phoneUtil.extractCountryCode(phoneNumber, nationalNumber: &nationalNumber)

		return nationalNumber as String?
	}

	/// Set directly the phone number. e.g "+33612345678"
	@objc open func set(phoneNumber: String) {
		let cleanedPhoneNumber: String = clean(string: phoneNumber)

		if let validPhoneNumber = getValidNumber(phoneNumber: cleanedPhoneNumber) {
			if validPhoneNumber.italianLeadingZero {
                phoneTextField.text = "0\(validPhoneNumber.nationalNumber.stringValue)"
			} else {
                phoneTextField.text = validPhoneNumber.nationalNumber.stringValue
			}
			setFlag(countryCode: FPNCountryCode(rawValue: phoneUtil.getRegionCode(for: validPhoneNumber))!)
		}
	}

	/// Set the country image according to country code. Example "FR"
	open func setFlag(countryCode: FPNCountryCode) {
		let countries = countryRepository.countries

		for country in countries {
			if country.code == countryCode {
				return fpnDidSelect(country: country)
			}
		}
	}

	/// Set the country image according to country code. Example "FR"
	@objc open func setFlag(key: FPNOBJCCountryKey) {
		if let code = FPNOBJCCountryCode[key], let countryCode = FPNCountryCode(rawValue: code) {

			setFlag(countryCode: countryCode)
		}
	}

	/// Set the country list excluding the provided countries
	open func setCountries(excluding countries: [FPNCountryCode]) {
		countryRepository.setup(without: countries)

		if let selectedCountry = selectedCountry, countryRepository.countries.contains(selectedCountry) {
			fpnDidSelect(country: selectedCountry)
		} else if let country = countryRepository.countries.first {
			fpnDidSelect(country: country)
		}
	}

	/// Set the country list including the provided countries
	open func setCountries(including countries: [FPNCountryCode]) {
		countryRepository.setup(with: countries)

		if let selectedCountry = selectedCountry, countryRepository.countries.contains(selectedCountry) {
			fpnDidSelect(country: selectedCountry)
		} else if let country = countryRepository.countries.first {
			fpnDidSelect(country: country)
		}
	}

	/// Set the country list excluding the provided countries
	@objc open func setCountries(excluding countries: [Int]) {
		let countryCodes: [FPNCountryCode] = countries.compactMap({ index in
			if let key = FPNOBJCCountryKey(rawValue: index), let code = FPNOBJCCountryCode[key], let countryCode = FPNCountryCode(rawValue: code) {
				return countryCode
			}
			return nil
		})

		countryRepository.setup(without: countryCodes)
	}

	/// Set the country list including the provided countries
	@objc open func setCountries(including countries: [Int]) {
		let countryCodes: [FPNCountryCode] = countries.compactMap({ index in
			if let key = FPNOBJCCountryKey(rawValue: index), let code = FPNOBJCCountryCode[key], let countryCode = FPNCountryCode(rawValue: code) {
				return countryCode
			}
			return nil
		})

		countryRepository.setup(with: countryCodes)
	}

	// Private

	@objc private func didEditText() {
        if let phoneCode = selectedCountry?.phoneCode, let number = phoneTextField.text {
			var cleanedPhoneNumber = clean(string: "\(phoneCode) \(number)")

//			if let validPhoneNumber = getValidNumber(phoneNumber: cleanedPhoneNumber) {
//				nbPhoneNumber = validPhoneNumber
//
//				cleanedPhoneNumber = "+\(validPhoneNumber.countryCode.stringValue)\(validPhoneNumber.nationalNumber.stringValue)"
//
//				if let inputString = formatter?.inputString(cleanedPhoneNumber) {
//                    phoneTextField.text = remove(dialCode: phoneCode, in: inputString)
//				}
//                (phoneTextField.delegate as? FPNTextFieldDelegate)?.fpnDidValidatePhoneNumber(textField: self, isValid: true,beginEidting: beginEditing)
//			} else
//            {
//				nbPhoneNumber = nil
//
//				if let dialCode = selectedCountry?.phoneCode {
//					if let inputString = formatter?.inputString(cleanedPhoneNumber) {
//                        phoneTextField.text = remove(dialCode: dialCode, in: inputString)
//					}
//				}
//                (phoneTextField.delegate as? FPNTextFieldDelegate)?.fpnDidValidatePhoneNumber(textField: self, isValid: false,beginEidting: beginEditing)
//			}
            (phoneTextField.delegate as? FPNTextFieldDelegate)?.fpnDidValidatePhoneNumber(textField: self, isValid: true, beginEidting: beginEditing)
		}
	}

	private func convert(format: FPNFormat) -> NBEPhoneNumberFormat {
		switch format {
		case .E164:
			return NBEPhoneNumberFormat.E164
		case .International:
			return NBEPhoneNumberFormat.INTERNATIONAL
		case .National:
			return NBEPhoneNumberFormat.NATIONAL
		case .RFC3966:
			return NBEPhoneNumberFormat.RFC3966
		}
	}

	private func updateUI() {
		if let countryCode = selectedCountry?.code {
			formatter = NBAsYouTypeFormatter(regionCode: countryCode.rawValue)
		}

		flagImageView.image = selectedCountry?.flag

		if let phoneCode = selectedCountry?.phoneCode {
			phoneCodeLabel.text = phoneCode
            self.updateConstraints()
		}
		didEditText()
	}

	private func clean(string: String) -> String {
		var allowedCharactersSet = CharacterSet.decimalDigits

		allowedCharactersSet.insert("+")

		return string.components(separatedBy: allowedCharactersSet.inverted).joined(separator: "")
	}

	private func getWidth(text: String) -> CGFloat {
		if let font = phoneCodeLabel.font {
			let fontAttributes = [NSAttributedString.Key.font: font]
			let size = (text as NSString).size(withAttributes: fontAttributes)

			return size.width.rounded(.up)
		} else {
			phoneCodeLabel.sizeToFit()

			return phoneCodeLabel.frame.size.width.rounded(.up)
		}
	}

	private func getValidNumber(phoneNumber: String) -> NBPhoneNumber? {
		guard let countryCode = selectedCountry?.code else { return nil }

		do {
			let parsedPhoneNumber: NBPhoneNumber = try phoneUtil.parse(phoneNumber, defaultRegion: countryCode.rawValue)
			let isValid = phoneUtil.isValidNumber(parsedPhoneNumber)

			return isValid ? parsedPhoneNumber : nil
		} catch _ {
			return nil
		}
	}

	private func remove(dialCode: String, in phoneNumber: String) -> String {
		return phoneNumber.replacingOccurrences(of: "\(dialCode) ", with: "").replacingOccurrences(of: "\(dialCode)", with: "")
	}

	private func getToolBar(with items: [UIBarButtonItem]) -> UIToolbar {
		let toolbar: UIToolbar = UIToolbar()

		toolbar.barStyle = UIBarStyle.default
		toolbar.items = items
		toolbar.sizeToFit()

		return toolbar
	}

	private func getCountryListBarButtonItems() -> [UIBarButtonItem] {
		let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissCountries))

		doneButton.accessibilityLabel = "doneButton"

		return [space, doneButton]
	}

	private func updatePlaceholder() {
		if let countryCode = selectedCountry?.code {
			do {
				let example = try phoneUtil.getExampleNumber(countryCode.rawValue)
				let phoneNumber = "+\(example.countryCode.stringValue)\(example.nationalNumber.stringValue)"

				if let inputString = formatter?.inputString(phoneNumber) {
                    phoneTextField.placeholder = remove(dialCode: "+\(example.countryCode.stringValue)", in: inputString)
				} else {
                    phoneTextField.placeholder = nil
				}
			} catch _ {
                phoneTextField.placeholder = nil
			}
		} else {
            phoneTextField.placeholder = nil
		}
	}
}
