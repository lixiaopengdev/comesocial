//
//  File.swift
//  AuthManagerKit
//
//  Created by li on 6/2/23.
//

import Foundation
import UIKit
import CSNetwork
class CSSignUpAgeView: CSAuthBaseView,KeyboardObserver,UITextFieldDelegate {
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
        self.addSubview(self.yearTextField)
        self.addSubview(self.monthTextField)
        self.addSubview(self.dayTextField)
        self.addSubview(self.nextButton)
        let button1Width = 113
        let button2Width = 84
        let button3Width = 68
        let buttonHeight = 48
        let buttonSpacing = 10
        
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
        yearTextField.snp.makeConstraints { make in
            make.top.equalTo(self.tileLabel2.snp.bottom).offset(24)
            make.left.equalToSuperview().offset((self.frame.width - CGFloat(button1Width + button2Width + button3Width + 2 * buttonSpacing)) / 2)
            make.width.equalTo(button1Width)
            make.height.equalTo(buttonHeight)
        }
        
        monthTextField.snp.makeConstraints { make in
            make.left.equalTo(yearTextField.snp.right).offset(buttonSpacing)
            make.centerY.equalTo(yearTextField.snp.centerY)
            make.width.equalTo(button2Width)
            make.height.equalTo(buttonHeight)
        }
        
        dayTextField.snp.makeConstraints { make in
            make.left.equalTo(monthTextField.snp.right).offset(buttonSpacing)
            make.centerY.equalTo(yearTextField.snp.centerY)
            make.width.equalTo(button3Width)
            make.height.equalTo(buttonHeight)
            make.right.equalToSuperview().inset((self.frame.width - CGFloat(button1Width + button2Width + button3Width + 2 * buttonSpacing)) / 2)
            
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
        titleLabel.text = "For legal reasons"
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    private lazy var tileLabel2: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldTitle1
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "We need your age"
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private lazy var yearTextField:UITextField = {
        let yearTextField = UITextField()
        yearTextField.font = .semiBoldFont(ofSize: 18)
        yearTextField.textColor = .white
        yearTextField.placeholder = ("Year")
        yearTextField.keyboardType = .numberPad
        yearTextField.delegate = self
        yearTextField.becomeFirstResponder()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        yearTextField.attributedPlaceholder = NSAttributedString(string: "Year", attributes: [NSAttributedString.Key.foregroundColor: UIColor.cs_lightGrey, NSAttributedString.Key.paragraphStyle:paragraphStyle])
        yearTextField.contentHorizontalAlignment = .center
        yearTextField.textAlignment = .center
        yearTextField.layer.cornerRadius = 12
        yearTextField.backgroundColor = .cs_cardColorB_40
        yearTextField.layer.shadowColor = UIColor.cs_primaryBlack.cgColor
        yearTextField.layer.shadowOffset = CGSizeMake(0, 2)
        yearTextField.layer.shadowOpacity = 0.5
        yearTextField.layer.shadowRadius = 2
        return yearTextField
    }()
    
    private lazy var monthTextField:UITextField = {
        let monthTextField = UITextField()
        monthTextField.font = .semiBoldFont(ofSize: 18)
        monthTextField.textColor = .white
        monthTextField.placeholder = "Month"
        monthTextField.keyboardType = .numberPad
        monthTextField.delegate = self
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        monthTextField.attributedPlaceholder = NSAttributedString(string: "Month", attributes: [NSAttributedString.Key.foregroundColor: UIColor.cs_lightGrey, NSAttributedString.Key.paragraphStyle:paragraphStyle])
        monthTextField.contentHorizontalAlignment = .center
        monthTextField.textAlignment = .center
        monthTextField.layer.cornerRadius = 12
        monthTextField.backgroundColor = .cs_cardColorB_40
        monthTextField.layer.shadowColor = UIColor.cs_primaryBlack.cgColor
        monthTextField.layer.shadowOffset = CGSizeMake(0, 2)
        monthTextField.layer.shadowRadius = 2
        monthTextField.layer.shadowOpacity = 0.5
        return monthTextField
    }()
    
    private lazy var dayTextField: UITextField = {
        let dayTextField = UITextField()
        dayTextField.font = .semiBoldFont(ofSize: 18)
        dayTextField.textColor = .white
        dayTextField.placeholder = "Day"
        dayTextField.keyboardType = .numberPad
        dayTextField.delegate = self
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        dayTextField.attributedPlaceholder = NSAttributedString(string: "Day",attributes: [NSAttributedString.Key.foregroundColor: UIColor.cs_lightGrey, NSAttributedString.Key.paragraphStyle: paragraphStyle] )
        dayTextField.contentHorizontalAlignment = .center
        dayTextField.textAlignment = .center
        dayTextField.layer.cornerRadius = 12
        dayTextField.backgroundColor = .cs_cardColorB_40
        dayTextField.layer.shadowColor = UIColor.cs_primaryBlack.cgColor
        dayTextField.layer.shadowRadius = 2
        dayTextField.layer.shadowOffset = CGSizeMake(0, 2)
        dayTextField.layer.shadowOpacity = 0.5
        return dayTextField
    }()
    
    private lazy var alertView: UIView = {
        let backView = UIView()
        backView.frame = self.bounds
        backView.alpha = 0
        backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        let alertView = UIView()
        alertView.tag = 99
        backView.addSubview(alertView)
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(60)
            make.trailing.equalToSuperview().inset(60)
        }
        alertView.backgroundColor = .white
        alertView.layer.cornerRadius = 20
        let title = UILabel()
        title.textColor = UIColor.cs_primaryBlack
        title.font = .boldHeadline
        title.tag = 100
        title.textAlignment = .center
        alertView.addSubview(title)
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(24)
            make.top.equalToSuperview().offset(24)
        }
        let image = UIImageView()
        alertView.addSubview(image)
        image.image = UIImage.bundleForImage(named: "age_fail")
        image.snp.makeConstraints { make in
            make.width.height.equalTo(84)
            make.top.equalTo(title.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        let detailLabel = UILabel()
        detailLabel.font = .regularSubheadline
        detailLabel.textColor = .darkGray
        detailLabel.numberOfLines = 0
        detailLabel.lineBreakMode = .byWordWrapping
        detailLabel.tag = 101
        detailLabel.textAlignment = .center
        alertView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(40)
        }
        let button = UIButton()
        button.setTitle("OK", for: .normal)
        button.titleLabel?.font = .regularBody
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 22
        button.backgroundColor = .cs_primaryPink
        button.addTarget(self, action: #selector(onClickAlertButton), for: .touchUpInside)
        alertView.addSubview(button)
        button.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(44)
            make.top.equalTo(detailLabel.snp.bottom).offset(24)
            make.bottom.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
       return backView
    }()
    
    @objc func onClickAlertButton() {
        self.hide()
    }
            
    func show(title:String, message:String) {
        self.addSubview(self.alertView)
        let label:UILabel = self.alertView.viewWithTag(100) as! UILabel
        let detailLabel:UILabel = self.alertView.viewWithTag(101) as! UILabel
        let alert:UIView = self.alertView.viewWithTag(99) as! UIView
        label.text = title
        detailLabel.text = message
        alert.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.alertView.alpha = 1
            alert.transform = CGAffineTransform.identity
        })
    }
    
    func hide() {
        // Animate the background view and the content view
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.alertView.alpha = 0
//            self.alertView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            self.alertView.removeFromSuperview()
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
        nextButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(180)
        }
        UIView.performWithoutAnimation {
            
            self.layoutIfNeeded()        }
    }
    
    override func nextButtonAction() {
        if self.checkTextField() {
            
            let regionCode = self.paramsDict["phoneCode"] as! String
            let mobileNo = self.paramsDict["phoneNum"] as! String
            let (mon, day) = formatMonthAndDay(month: monthTextField.text!, day: dayTextField.text!)
            let birthday = self.yearTextField.text! + mon + day
            self.paramsDict["birthday"] = birthday
            Network.oriRequest(CSAuthService.checkBirthday(regionCode: regionCode, mobileNo: mobileNo, birthday: birthday), completion: {[weak self] result in
                switch result {
                case let .success(data):
                    let valid:Bool = (data as! Dictionary<String, Any>)["pw_valid"] as! Bool
                    if valid {
                        self?.nextHandler?(.authViewStyleUserName, self?.paramsDict ?? .init())
                    } else {
                        let dict = (data as! Dictionary<String ,Any>)["detail_error"] as? Dictionary<String ,Any>
                        if dict?.count ?? 0 > 0 {
                            let title = dict?.keys.first
                            let message = dict?.values.first
                            self?.show(title: title ?? "", message: message as! String)
                        }
                    }
                    break
                case let .failure(_):
                    break
                }
            })
        }
    }
    
    func checkTextField() -> Bool{
        self.resetTextField()
        var yearChecked:Bool = false
        var monChecked:Bool = false
        var dayChecked:Bool = false
            if let year = Int(yearTextField.text ?? ""), year >= 1900 && year <= 9999 {
                yearChecked = true
            } else {
                yearTextField.layer.borderColor = UIColor.cs_warningRed.cgColor
                yearTextField.layer.borderWidth = 1
                yearChecked = false
            }
        
            if let month = Int(monthTextField.text!), month >= 1 && month <= 12 {
                monChecked = true
            } else {
                monthTextField.layer.borderColor = UIColor.cs_warningRed.cgColor
                monthTextField.layer.borderWidth = 1
                monChecked = false
            }
            
            if let day = Int(dayTextField.text!), day >= 1 && day <= 31 {
                dayChecked = true
            } else {
                dayTextField.layer.borderColor = UIColor.cs_warningRed.cgColor
                dayTextField.layer.borderWidth = 1
                dayChecked = false
            }
        return yearChecked&&monChecked&&dayChecked
    }
    
    func formatMonthAndDay(month: String, day: String) -> (String, String) {
        let formattedMonth = month.count == 1 ? "0" + month : month
        let formattedDay = day.count == 1 ? "0" + day : day
        return (formattedMonth, formattedDay)
    }
    
    func resetTextField() {
        yearTextField.layer.borderColor = UIColor.clear.cgColor
        yearTextField.layer.borderWidth = 0
        
        monthTextField.layer.borderWidth = 0
        monthTextField.layer.borderColor = UIColor.clear.cgColor
        
        dayTextField.layer.borderColor = UIColor.clear.cgColor
        dayTextField.layer.borderWidth = 0
    }
}

