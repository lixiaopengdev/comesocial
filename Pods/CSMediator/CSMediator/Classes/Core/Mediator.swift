//
//  Bichon.swift
//  CSMediator
//
//  Created by 于冬冬 on 2023/6/16.
//

import Swinject
import URLNavigator

public class Mediator {
    
    static let shared = Mediator()
    var modules:[ObjectIdentifier: MediatorModuleProtocol] = [:]
    let container = Container()
    let navigator: NavigatorProtocol = Navigator()

    class func allRegisteredModules() -> [MediatorModuleProtocol] {
        return shared.modules.values.sorted(by: { $0.priority.rawValue > $1.priority.rawValue })
    }
    
    public class func registerModuleInstance<T: MediatorModuleProtocol>(_ module: T) {
        let classIdentifier = ObjectIdentifier(module)
        shared.modules[classIdentifier] = module
    }
    
    public class func unregisterModuleInstance<T: MediatorModuleProtocol>(_ module: T) {
        let classIdentifier = ObjectIdentifier(module)
        shared.modules.removeValue(forKey: classIdentifier)
    }
    
    public class func bootstrap() {
        let modules = allRegisteredModules()
        for module in modules {
            if module.synchronously {
                module.bootstrap()
            } else {
                DispatchQueue.global(qos: .default).async {
                    module.bootstrap()
                }
            }
        }
    }
}


