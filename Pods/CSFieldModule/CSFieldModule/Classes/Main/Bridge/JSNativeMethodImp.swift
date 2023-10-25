//
//  NativeMethodImp.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/10.
//

import Foundation
import JSEngineKit
import SwiftyJSON

class JSNativeMethodImp: YZNativeMethodProtocol {
    
    func takePhoto(_ instanceId: String, data: [AnyHashable : Any]) {
        print(data)
        let widget = assembly?.widgetContainer().getWidgetWith(instanceId: instanceId)
        widget?.takePhoto(data: JSON(data))
    }
    
    
    func updateRoomInfo(_ instanceId: String, data: [AnyHashable : Any]) {
        print(data)
        PropertiesMessage(assembly: assembly!).updateRoomInfo(data: JSON(data)["js_data"])
    }
    
    func enterRoomSetUp(_ instanceId: String, data: [AnyHashable : Any]) {
        print(data)

    }
    
    func applyVideoEffectFilter(_ instanceId: String, data: [AnyHashable : Any]) {
        print(data)
        let effect = JSON(data)["js_data"]["effect_id"].stringValue
        assembly?.resolve(type: FaceTimeClient.self).changeEffect(name: effect)

    }
    
    func getCurrentCameraStatus(_ instanceId: String, data: [AnyHashable : Any]) -> [AnyHashable : Any] {
        return [AnyHashable : Any]()
    }
    
    func getCurrentMicrophoneStatus(_ instanceId: String, data: [AnyHashable : Any]) -> [AnyHashable : Any] {
        print(data)

        return [AnyHashable : Any]()

    }
    
    func applyAudioFilter(_ instanceId: String, data: [AnyHashable : Any]) {
        print(data)
        let effect = JSON(data)["js_data"]["effect_id"].stringValue
        assembly?.resolve(type: AudioClient.self).changeEffect(name: effect)
    }
    
    func silence(_ instanceId: String, data: [AnyHashable : Any]) {
        print(data)

    }
    
    func getCurrentUserInfo(_ instanceId: String, data: [AnyHashable : Any]) -> [AnyHashable : Any] {
        print(data)

//        let value: JSON = JSON(data)
//        if let args = value["args"].array,
//           let action = args.first?.string {
//            switch action {
//            case "empty":
//                return data
//            default:
//                return data
//            }
//        }
        return data
    }
    
    func uploadPhoto(_ instanceId: String, data: [AnyHashable : Any]) {
        print(data)
        let widget = assembly?.widgetContainer().getWidgetWith(instanceId: instanceId)
        widget?.uploadPhoto(data: JSON(data))
    }
    
    
    // 当前活跃的场
    var assembly: FieldAssembly? {
        return FieldRoot.shared.activeField
    }
    
    func alertAction(_ instanceId: String, data: [AnyHashable : Any]) {
        
        let message = data["content"] as? String ?? "empty"
        let alertController = UIAlertController(title: "alertAction",
                                                message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "cancle", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        assembly?.viewController?.present(alertController, animated: true)
    }
    
    func brodcastAction(_ instanceId: String, data: [AnyHashable : Any]) {
        var newData = data
        newData["instanceId"] = instanceId
        assembly?.roomMessageChannel().sendMessage(event: .brodcastAction, data: newData)
    }
    
    func renderWidget(withJSRender instanceId: String, data: [AnyHashable : Any]) {
        print(data)

        PropertiesMessage(assembly: assembly!).createWidget(instanceId: instanceId, data: data)
       
    }
    
    func startVideoCapture(_ instanceId: String, data: [AnyHashable : Any]) {
        PropertiesMessage(assembly: assembly!).ChangeMyVideo(open: true)
        
    }
    
    func stopVideoCapture(_ instanceId: String, data: [AnyHashable : Any]) {
        PropertiesMessage(assembly: assembly!).ChangeMyVideo(open: false)

    }
    
    func switchCameraSource(_ instanceId: String, data: [AnyHashable : Any]) {
//        assembly?.resolve(type: FaceTimeClient.self).switchCamera()

    }
    
    func startAudioCapture(_ instanceId: String, data: [AnyHashable : Any]) {
        assembly?.resolve(type: AudioClient.self).startAudio()

    }
    
    func stopAudioCapture(_ instanceId: String, data: [AnyHashable : Any]) {
        assembly?.resolve(type: AudioClient.self).stopAudio()
    }
    
    func applyVideoAvatar(_ instanceId: String, data: [AnyHashable : Any]) {
        
    }
    
    func applyVideoFilter(_ instanceId: String, data: [AnyHashable : Any]) {
        
    }
    
}

