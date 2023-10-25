//
//  Properties.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/2/21.
//

import Foundation
import SwiftyJSON
import CSNetwork
import CSAccountManager
import Combine
import CSUtilities

class Properties: FieldComponent {
    var assembly: FieldAssembly
    var cancellableSet: Set<AnyCancellable> = []
    @Published public private(set) var isLoading = false
    private var mergeQueue = [JSON]()
    
    private(set) var fullProp: JSON = [:]
    
    var currentVersion: UInt {
        fullProp[PK.version].uIntValue
    }
    
    var latestVersion: UInt = 0
    
    required init(assembly: FieldAssembly) {
        self.assembly = assembly
    }
    
    func initialize() {
        updateFullData()
        assembly
            .roomMessageChannel()
            .$isJoined
            .sink { [weak self] joined in
                if joined {
                    self?.updateFullData()
                }
            }
            .store(in: &cancellableSet)
    }
    
    func updateFullData() {
        if isLoading { return }
        isLoading = true
        Network.oriRequest(FieldService.fieldLive(fieldId: assembly.id), completion:  {[weak self] result in
            switch result {
            case let .success(data):
                let json = JSON(data)
                self?.handleFullData(prop: json)
            case let .failure(error):
                self?.handleError(error.localizedDescription)
            }
            self?.isLoading = false
        })
    }
    
    func getUserPropety(id: UInt) -> JSON {
        return fullProp[PK.user][String(id)]
    }
    
    func enqueue(merge body: String) {
        guard let mergeJson = try? JSON(parseJSON: body) else {
            assertionFailure("wrong data: \(body)")
            return
        }
        updateLatestVersionWithProp(mergeJson[PK.prop])
        if isLoading {
            mergeQueue.append(mergeJson)
        } else {
           handleMerge(mergeJson)
        }
    }
    
    
    private func handleFullData(prop: JSON) {
        fullProp = prop
        updateLatestVersionWithProp(fullProp)
        
        for mergeMessage in mergeQueue {
            let merger = mergeMessage[PK.prop]
           mergeProp(merger)
        }
        mergeQueue.removeAll()
        
        checkDataComplete()
        setupData()
    }
    
    func setupData() {
        handleUseJs(prop: fullProp)
        initializeAllWidget()
        handleUser(prop: fullProp)
        handleInfo()
    }
    
    func handleMerge(_ data: JSON) {
        // 根据action出发事件
        guard let actionString = data[PK.action].string,
              let action = ProperitesAction(rawValue: actionString) else {
                  handleError("action is null")
                  return
              }
        let prop = data[PK.prop]
        
        mergeProp(prop)
        checkDataComplete()
        
        switch action {
        case .createWidget:
            handleCreateWidget(prop: prop)
        case .updateWidget:
            handleUpdateWidget(prop: prop)
        case .useJS:
            handleUseJs(prop: prop)
        case .vedioStatus, .photo:
            handleUser(prop: prop)
        case .propInit:
            updateFullData()
        case .removeMine:
            break
        case .updateRoomInfo:
            handleInfo()
        case .updateMeWidget:
            handleUpdateUserWidget(prop: prop)
//        case .clearMe:
//            break
        }
        

    }
    
    // 检查数据完整性
    func checkDataComplete() {
        assert(currentVersion == latestVersion, "currentVersion != latestVersion")
    }
    
    func updateLatestVersionWithProp(_ json: JSON) {
        latestVersion = max(latestVersion, json[PK.version].uIntValue)
    }
    
    func mergeProp(_ prop: JSON) -> Bool {
        
        let mergeVersion = prop[PK.version].uIntValue
        if mergeVersion != currentVersion + 1 {
            updateFullData()
            return false
        }
        do {
            try fullProp.merge(with: prop)
            return true
        } catch {
            handleError(error.localizedDescription)
            return false
        }
    }
    
    
    private func handleError(_ error: String) {
        HUD.showError(error)
//        assertionFailure(error)
    }
    
    func willDestory() {
        PropertiesMessage(assembly: assembly).removeMine()
    }
}


private extension Properties {
    func handleCreateWidget(prop: JSON) {
        guard let widgetData = prop[PK.widget].dictionary?.values.first else {
            return
        }
        assembly.widgetContainer().mount(widgetData)
    }
    
    
    func initializeAllWidget() {
        let facetimeData: [AnyHashable : Any] = [
            "js_data": [
                "widget":[
                    "content": [
                        "id": "facetime",
                        "componentType": "BaseVideoComponent"
                    ]
                ]
            ]
        ]
        assembly.widgetContainer().unmountAll()
        guard var widgetDatas = fullProp[PK.widget].dictionary?.values else {
            PropertiesMessage(assembly: assembly).createWidget(instanceId: "facetime", data: facetimeData)
            return
        }
        
        if widgetDatas.isEmpty {
            PropertiesMessage(assembly: assembly).createWidget(instanceId: "facetime", data: facetimeData)
        }
        
        let sortedWidgets = widgetDatas.sorted { w1, w2 in
           return w1["order"].intValue < w2["order"].intValue
        }

        for widgetData in sortedWidgets {
            assembly.widgetContainer().mount(widgetData)
        }
    }
    
    func handleUpdateWidget(prop: JSON) {
        guard let widgetData = prop[PK.widget].dictionary?.first else {
            return
        }
        let fullWidgetData = fullProp[PK.widget][widgetData.key]
        assembly.widgetContainer().updateWidget(id: widgetData.key, full: fullWidgetData, change: widgetData.value)
    }
    
    func handleUpdateUserWidget(prop: JSON) {
        let userValueDict = prop[PK.user].dictionaryValue
        for (userId, userValue) in userValueDict {
            let userfullWidgets = fullProp[PK.user][userId]["widgets"]
            let userUpdateWidgets = userValue["widgets"].dictionaryValue
            for (widgetId, widgetValue) in userUpdateWidgets {
                assembly.widgetContainer().updateUserWidget(id: widgetId, userId: userId, full: userfullWidgets[widgetId], change: widgetValue)
            }
        }
    }
    
    func handleUseJs(prop: JSON) {
        guard let jsNames = prop[PK.js].dictionary?.values else {
            return
        }
        for js in jsNames {
            assembly.cardManager().syncJs(name: js.stringValue)
        }
    }
    
    func handleUser(prop: JSON) {
        guard let users = prop[PK.user].dictionary else {
            return
        }
        for user in users {
            let userKit = assembly.usersManager().getUser(UInt(user.key) ?? 0)
            userKit?.syncUser(data: user.value)
        }
    }
    
    func handleInfo() {
        assembly.backgroundLayer().updateRoomInfo(fullProp[PK.info])
    }
}


