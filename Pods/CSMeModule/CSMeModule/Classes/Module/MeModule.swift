//
//  MeModule.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/6/20.
//

import CSMediator


public class MeModule: MediatorModuleProtocol {
    
    public static let shared = MeModule()
    
    public func bootstrap() {
        Mediator.register(MeService.ViewControllerService.self) { _ in
            return MeViewControllerServiceImp()
        }
        
        Mediator.register(MeService.ProfileService.self) { _ in
            return MeProfileServiceImp()
        }.inObjectScope(.container)
        
        Mediator.register("http://<path:_>", webViewControllerFactory)
        Mediator.register("https://<path:_>", webViewControllerFactory)
    }
    
    func webViewControllerFactory(_ url: URLConvertible, _ values: [String: Any], _ context: Any?) -> UIViewController? {
        return Mediator.resolve(MeService.ViewControllerService.self)?.webViewController(url: url.urlValue)
    }
}
