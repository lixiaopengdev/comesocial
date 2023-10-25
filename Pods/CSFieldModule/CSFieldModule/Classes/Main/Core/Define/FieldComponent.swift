//
//  FieldComponentInit.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/2/3.
//

import Combine

protocol FieldComponent: AnyObject {
    init(assembly: FieldAssembly)
    var assembly: FieldAssembly { get }
    
    // life cycle
    func initialize()
    func willDestory()
    func didDestory() // 不能访问assembly

}

extension FieldComponent {
    func willDestory() {
        
    }
    
    func didDestory() {
        
    }
    
    func initialize() {
        
    }
}

class FieldBaseView: UIView, FieldComponent {
    
    var cancellableSet: Set<AnyCancellable> = []

    let assembly: FieldAssembly
    
    required init(assembly: FieldAssembly) {
        self.assembly = assembly
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        
    }
    
    @objc func willDestory() {
        
    }
}


