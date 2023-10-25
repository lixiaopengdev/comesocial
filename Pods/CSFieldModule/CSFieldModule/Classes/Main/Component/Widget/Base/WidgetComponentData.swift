//
//  WidgetComponentData.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/3/15.
//

import SwiftyJSON
import UIKit
import ObjectMapper
import CSUtilities

class WidgetComponentData: WidgetLifeCycle {
    func mount() {
        for fragment in fragments {
            fragment.value.value?.mount()
        }
    }
    
    func willUnmount() {
        for fragment in fragments {
            fragment.value.value?.willUnmount()
        }
    }
    
    func didUnmount() {
        for fragment in fragments {
            fragment.value.value?.didUnmount()
        }
    }
    
    func willDisplay() {
        for fragment in fragments {
            fragment.value.value?.willDisplay()
        }
    }
    
    var height: CGFloat {
        
        func calH(_ value: [WidgetFragment]) -> CGFloat {
            let space: CGFloat = 15
            let h = value.reduce(0, { $0 + $1.height + space }) - space
            return max(0, h)
        }
        
        let sumH = calH(top) + calH(bottom) + max(calH(leading), calH(trailing))
        return sumH
    }
    
    
    var top: [WidgetFragment] = []
    var bottom: [WidgetFragment] = []
    var leading: [WidgetFragment] = []
    var trailing: [WidgetFragment] = []
    
    let data: JSON
    let assembly: FieldAssembly
    let id: String
    var instanceid: String {
        return id.deletingPathExtension
    }
    
    var fragments: [String: WeakWrapper<WidgetFragment>] = [:]

    init?(assembly: FieldAssembly, data: JSON) {
        
        guard let id = data["id"].string else {
            return nil
        }
        
        self.id = id
        self.data = data
        self.assembly = assembly
        parseFragments()
        update(full: data, change: data)
        
    }
    
    func parseFragments() {
        
        let contentData = data["data"]["js_data"]["widget"]["content"]
        
        if contentData["top"].exists() {
            addFragement(values: contentData["top"].arrayValue, value: &top)
            addFragement(values: contentData["bottom"].arrayValue, value: &bottom)
            
//            let loop = Int.random(in: 1...10)
//
//            for _ in 0...loop {
//                addFragement(values: contentData["leading"].arrayValue, value: &leading)
//            }
            addFragement(values: contentData["leading"].arrayValue, value: &leading)
            addFragement(values: contentData["trailing"].arrayValue, value: &trailing)
        } else if contentData.type == .array {
            addFragement(values: contentData.arrayValue, value: &top)
        } else {
            addFragement(values: [contentData], value: &top)
        }
    }
    
    func addFragement(values: [JSON], value: inout [WidgetFragment]) {
        
        for fragmentJson in values {
            if var fragmentMap = fragmentJson.dictionaryObject {
                fragmentMap["assembly"] = assembly
                if let fragment = Mapper<WidgetFragment>().map(JSON: fragmentMap) {
                    fragment.parentComponent = self
                    fragment.initialize()
                    fragments[fragment.id] = WeakWrapper(fragment)
                    value.append(fragment)
                }
            }
        }
    }
    
    
    

    
    func update(full: JSON, change: JSON) {
        let changeData = change["sync"].dictionaryValue
        let fullData = full["sync"].dictionaryValue
        for (fragmentId, fragmentData) in changeData {
            fragments[fragmentId]?.value?.update(full: fullData[fragmentId] ?? JSON(), change: fragmentData)
        }
    }
    
    func updateUser(userId: String, full: JSON, change: JSON) {
        let changeData = change.dictionaryValue
        let fullData = full.dictionaryValue
        for (fragmentId, fragmentData) in changeData {
            fragments[fragmentId]?.value?.updateUser(userId: userId, full: fullData[fragmentId] ?? JSON(), change: fragmentData)
        }
    }
    
    func receive(widgetMessage: JSON) {
        let fragmentMessages = widgetMessage.dictionaryValue
        for (fragmentId, fragmentMessage) in fragmentMessages {
            fragments[fragmentId]?.value?.receive(message: fragmentMessage)
        }
    }
    
    /// 方法
    final func sync(data: JSON) {
        let newData: JSON = ["sync": data]
        PropertiesMessage(assembly: assembly).updateWidget(instanceId: id, data: newData)
    }
    
    final func syncMe(widget data: JSON) {
        let newData: JSON = ["widgets": [id: data]]
        PropertiesMessage(assembly: assembly).UpdateMe(widget: newData)
    }
    
    final func getWidgetFrom(user uid: UInt) -> JSON {
        return assembly.properties().getUserPropety(id: uid)["widgets"][id]
    }
    // {widgetId: {fragmentId: value}}
    final func send(data: JSON) {
        let newData: JSON = [id: data]
        guard let message = newData.rawString(options: []) else { return }
        assembly.roomMessageChannel().sendMessage(event: FieldEvent.widgetMessage, message: message)
    }
    
    func invalidateHeight() {
        assembly.widgetContainer().updateWidget(self)
    }
    
}

extension WidgetComponentData {
    func uploadPhoto(data: JSON) {
        
        for fragment in fragments {
            if let upload = fragment.value.value as? UploadImageCapacity {
                upload.uploadPhoto(data: data)
            }
        }
    }
    
    func takePhoto(data: JSON) {
        
        for fragment in fragments {
            if let upload = fragment.value.value as? TakePhotoCapacity {
                upload.takePhoto(data: data)
            }
        }
    }
}
