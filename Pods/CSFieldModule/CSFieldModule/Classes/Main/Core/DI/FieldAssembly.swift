//
//  FieldAssembly.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/2/3.
//

import SnapKit
import Dip
import CSUtilities
import Combine
import CSNetwork

class FieldAssembly {
    
    enum Status {
        case loading
        case succeed(FieldModel)
        case fail(String)
    }
    
    
    let dip = DependencyContainer()
    var cancellableSet: Set<AnyCancellable> = []
    var components: [WeakWrapper<FieldComponent>] = []

    @Published private(set) var status: Status = .loading
    
    var destroyed = false
    
    let id: UInt
    var fieldName: String? {
        if case .succeed(let field) = status {
            return field.name
        }
        return nil
    }
    weak var viewController: FieldViewController?
    
    init(id: UInt) {
        self.id = id
    }
    
    func bootstrap() {
        
        guard id != 0 else {
            self.status = .fail("Field Id Error")
            return
        }
        Network
            .requestPublisher(FieldService.field(id: id))
            .mapModel(FieldModel.self)
            .sink { [weak self] model in
                self?.status = .succeed(model)
            } failure: { error in
                self.status = .fail(error.errorTips ?? "Network Error")
            }
            .store(in: &cancellableSet)
        
        resolve(type: RoomMessageChannel.self).bootstrap()
        //        resolve(type: Properties.self)
        //        healthReader().request()
        
        FieldRoot.shared.joinField(assembly: self)
    }
    
 
    func resolve<T: FieldComponent>() -> T {
        if destroyed {
            assertionFailure("field destroying")
        }
        if let value: T = try? dip.resolve() {
            return value
        }
        let value = T.init(assembly: self)
 
        if !destroyed {
            dip.register { value as T }
            components.append(WeakWrapper(value))
        }
        value.initialize()
        return value
    }
    
    func resolve<T: FieldComponent>(type: T.Type) -> T {
        return resolve()
    }
    
    func destroy() {
        for com in components {
            com.value?.willDestory()
        }
        destroyed = true
        for com in components {
            com.value?.didDestory()
        }

        dip.reset()
        try! dip.bootstrap()
    }
    
    deinit {
        print("FieldAssembly deinit")
        let weakRs = components
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print(" ======= field deinit begin \(weakRs.count)")
            for weakR in weakRs {
                if let com = weakR.value {
                    print(com)
                    assertionFailure("\(com) leak")
                }
            }
            print(" ======= field deinit end")
        }
    }
}

extension FieldAssembly {
    
//    func viewController() -> FieldViewController {
//        return resolve()
//    }
    
    func widgetContainer() -> WidgetContainerView {
        return resolve()
    }
    
    func properties() -> Properties {
        return resolve()
    }
    
    func cardManager() -> CardManager {
        return resolve()
    }
    
    func roomMessageChannel() -> RoomMessageChannel {
        return resolve()
    }
    
    func usersManager() -> UsersManager {
        return resolve()
    }
    
    func photoManager() -> PhotoManager {
        return resolve()
    }
    
    func healthReader() -> HealthReader {
        return resolve()
    }
}

extension FieldAssembly {
    func backgroundLayer() -> BackgroundLayer {
        return resolve()
    }
}
