//
//  TestWidget.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/6.
//
//
//import UIKit
//import CSUtilities
//import JSEngineKit
//import SwiftyJSON
//import Combine
//
//class TestWidget: WidgetBaseView {
//    
//   @Published var value = 0
//    lazy var btn1: UIButton = {
//        let button = UIButton(type: .system)
//        button.addTarget(self, action: #selector(action1), for: .touchUpInside)
//        return button
//    }()
//    
//    lazy var btn2: UIButton = {
//        let button = UIButton(type: .system)
//        button.addTarget(self, action: #selector(action2), for: .touchUpInside)
//        return button
//    }()
//    
//    lazy var btn3: UIButton = {
//        let button = UIButton(type: .system)
//        button.addTarget(self, action: #selector(action3), for: .touchUpInside)
//        return button
//    }()
//    
//    override var height: CGFloat {
//        return 150
//    }
//    
//    override func initialize() {
//        backgroundColor = UIColor.random()
//        
//        addSubview(btn1)
//        addSubview(btn2)
//        addSubview(btn3)
//        btn1.snp.makeConstraints { make in
//            make.top.equalTo(20)
//            make.centerX.equalTo(self.snp.centerX)
//        }
//        
//        btn2.snp.makeConstraints { make in
//            make.bottom.equalTo(-20)
//            make.centerX.equalTo(self.snp.centerX)
//        }
//        
//        btn3.snp.makeConstraints { make in
//            make.centerY.equalTo(self.snp.centerY)
//            make.centerX.equalTo(self.snp.centerX)
//        }
//        
//        btn1.setTitle(btn1Name, for: .normal)
//        btn2.setTitle(btn2Name, for: .normal)
//        btn3.setTitle("add btn1", for: .normal)
//        
//        $value.sink { [weak self] num in
//            self?.btn1.setTitle(String(num), for: .normal)
//        }.store(in: &cancellableSet)
//        
//        updateValues()
//
//    }
//    
//    var content: JSON? {
//        return data?["data"]["content"]
//    }
//    
//    var btn1Name: String? {
//        return content?["button1"]["widgetId"].string
//    }
//    
//    var btn2Name: String? {
//        return content?["button2"]["widgetId"].string
//    }
//    
//    var btn1Action: String? {
//        return content?["button1"]["action"].string
//    }
//    
//    var btn2Action: String? {
//        return content?["button2"]["action"].string
//    }
//    
//    @objc func action1() {
//        YZJSEngineManager.shared().callJSMethod(btn1Action!, instanceId: id.deletingPathExtension, args: nil)
//    }
//
//    @objc func action2() {
//        YZJSEngineManager.shared().callJSMethod(btn2Action!, instanceId: id.deletingPathExtension, args: nil)
//
//    }
//    
//    @objc func action3() {
//
//        PropertiesMessage(assembly: assembly).updateWidget(instanceId: id, data: ["title": value + 1])
//    }
//    
//    override func updateData(_ widget: [String : Any]?) {
//        guard let widget = widget else {
//            return
//        }
//        
//        let update = JSON(widget)
//        try? data?.merge(with: update)
//        updateValues()
//    }
//    
//    func updateValues() {
//        if let value = data?["title"].int {
//            self.value = value
//        }
//    }
//}
