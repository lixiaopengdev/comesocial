//
//  WidgetFragment.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/3/15.
//

import Foundation
import ObjectMapper
import CSUtilities
import UIKit
import SwiftyJSON
import Combine

class WidgetFragment: StaticMappable, FragmentLifeCycle {
    
    let id: String
    let assembly: FieldAssembly
    let type: FragmentType
    weak var parentComponent: WidgetComponentData?
    var cancellableSet: Set<AnyCancellable> = []
    
    var height: CGFloat {
        return 0
    }
    
    func buildView() -> WidgetFragmentView {
        return type.widgetFragmentViewType.init(fragment: self)
    }
    
    required init(id: String, assembly: FieldAssembly, type: FragmentType) {
        self.id = id
        self.assembly = assembly
        self.type = type
    }
    
    static func objectForMapping(map: ObjectMapper.Map) -> ObjectMapper.BaseMappable? {
        guard let id: String = try? map.value("id") else {
            return nil
        }
        
        guard let type: FragmentType = try? map.value("componentType", using: EnumTransform<FragmentType>()) else {
            return nil
        }
        
        guard let assembly: FieldAssembly = try? map.value("assembly") else {
            return nil
        }
        
        return type.widgetFragmentType.init(id: id, assembly: assembly, type: type)
    }
    
    
    
    func mapping(map: ObjectMapper.Map) {
        
    }
    
    // MARK: 子类重写
    func update(full: JSON, change: JSON) {
        
    }
    
    func updateUser(userId: String, full: JSON, change: JSON) {
        
    }
    
    func receive(message: JSON) {
        
    }
    
    // life cycle
    
    func initialize() {
        
    }
    
    func mount() {
        
    }
    
    func willDisplay() {
        
    }
    
    func willUnmount() {
        
    }
    
    func didUnmount() {
        
    }
    
    
    // MARK: 父类提供的方法
    
    /// 保存值
    final func syncData(value: JSON) {
        let data: JSON = [id: value]
        parentComponent?.sync(data: data)
    }
    
    /// 保存用户值
    final func syncMe(fragment value: JSON) {
        let data: JSON = [id: value]
        parentComponent?.syncMe(widget: data)
    }
    
    final func getFragemtFrom(user uid: UInt) -> JSON {
        return parentComponent?.getWidgetFrom(user: uid)[id] ?? JSON()
    }
    
    /// 不保存
    final func sendData(value: JSON) {
        let data: JSON = [id: value]
        parentComponent?.send(data: data)
    }
    

    
    final func invalidateHeight() {
        parentComponent?.invalidateHeight()
    }

}

extension WidgetFragment {
    static var widgetWidth: CGFloat {
        return Device.UI.screenWidth - 30
    }
}
