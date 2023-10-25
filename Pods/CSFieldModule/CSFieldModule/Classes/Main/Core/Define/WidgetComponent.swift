//
//  WidgetComponent.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/6.
//

import Foundation
import SwiftyJSON
import Combine

protocol WidgetComponent: AnyObject {
    
    init(assembly: FieldAssembly, id: String, data: JSON?)
    var assembly: FieldAssembly { get }
    
    var id: String { get }

    var view: UIView { get }
    var height: CGFloat { get }
    
    func willDestory()
    func updateData(_ data: [String: Any]?)
    
}





class WidgetBaseView: UIView, WidgetComponent {

    var cancellableSet: Set<AnyCancellable> = []

    var view: UIView {
       return self
    }
    
    var height: CGFloat {
        fatalError("sub has not been implemented")
    }
    
    let assembly: FieldAssembly
    let id: String
    var data: JSON?
    required init(assembly: FieldAssembly, id: String, data: JSON?) {
        self.assembly = assembly
        self.id = id
        self.data = data
        super.init(frame: .zero)
        layerCornerRadius = 14
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        
    }
    
    @objc func willDestory() {
        
    }
    
    @objc func updateData(_ data: [String: Any]?) {
        
    }
    
}
