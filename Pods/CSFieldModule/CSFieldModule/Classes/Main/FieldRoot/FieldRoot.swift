//
//  FieldRoot.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/10.
//

import Foundation
import CSWebsocket
import CSUtilities

class FieldRoot {
    
    private init() {}
    static let shared = FieldRoot()
    static let nameSpace: String = "default"
    
    var assemblys: [UInt: FieldAssembly] = [:]
    var activeField: FieldAssembly?
    
    var fieldNamespaceClient: NamespaceClient {
        return ConnectClient.shared.getNamespaceClient(FieldRoot.nameSpace)
    }
    
    func registerMessageChannel() {
        ConnectClient.shared.registerNamespace(FieldRoot.nameSpace)
    }
    
    
    func joinField(assembly: FieldAssembly) {
        if let oldAssembly = assemblys[assembly.id] {
            assertionFailure("Field: \(String(describing: oldAssembly.fieldName)) 未清除")
            if assembly !== oldAssembly {
                leaveField(assembly.id)
            }
        }
        assemblys[assembly.id] = assembly
        activeField = assembly
    }

    func leaveField(_ id: UInt) {
        guard let fieldAssembly = assemblys.removeValue(forKey: id) else {
//            assertionFailure("Field: \(id) 已经不存在")
            return
        }
        fieldAssembly.destroy()
        activeField = nil

    }
    
}
