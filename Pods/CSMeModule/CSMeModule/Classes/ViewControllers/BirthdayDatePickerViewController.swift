//
//  BirthdayDatePickerViewController.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/5/9.
//

import CSBaseView
//import SnapKit
//import CSAccountManager
import CSUtilities
//import Foundation

class BirthdayDatePickerViewController: BaseViewController {
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 1900
        components.month = 1
        components.day = 1
        let minDate = calendar.date(from: components)
        datePicker.minimumDate = minDate
        datePicker.maximumDate = Date()
//        datePicker.overrideUserInterfaceStyle = .light
        // 设置日期格式
        datePicker.datePickerMode = .date
        datePicker.overrideUserInterfaceStyle = .dark
        datePicker.tintColor = .red
        // 添加响应方法
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        return datePicker
    }()
    
    lazy var cancelBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.cs_primaryPink, for: .normal)
        button.titleLabel?.font = .regularHeadline
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()
    
    lazy var doneBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.cs_primaryPink, for: .normal)
        button.titleLabel?.font = .regularHeadline
        button.addTarget(self, action: #selector(done), for: .touchUpInside)
        return button
    }()
    
    lazy var container: UIView = {
        let view = UIView()
        return view
    }()
    
    var selectedDateCallBack: Action1<Date>?
    var selectedDate: Date?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cs_primaryBlack
        container.backgroundColor = .cs_cardColorA_10
        view.cornerRadius(corners: [.topLeft, .topRight], radius: 20)
        
        if let selectedDate = selectedDate {
            datePicker.date = selectedDate
        }
        view.addSubview(container)
        view.addSubview(datePicker)
        view.addSubview(cancelBtn)
        view.addSubview(doneBtn)
        
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        datePicker.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(60)
        }
        cancelBtn.snp.makeConstraints { make in
            make.left.top.equalTo(16)
        }
        doneBtn.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.right.equalTo(-16)
        }
    }
    
    @objc func datePickerChanged() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: datePicker.date)
        print("Selected date: \(dateString)")
    }
    
    override var backgroundType: BackgroundType {
        return .none
    }
    
    @objc func cancel() {
        dismiss(animated: true)
    }
    
    @objc func done() {
        cancel()
        selectedDateCallBack?(datePicker.date)
    }
    
}
