//
//  Mediator+URL.swift
//  CSMediator
//
//  Created by 于冬冬 on 2023/6/20.
//

import Foundation
import URLNavigator
public typealias URLConvertible = URLNavigator.URLConvertible
public extension Mediator {
    
   static func register(_ pattern: URLPattern, _ factory: @escaping ViewControllerFactory) {
        Mediator.shared.navigator.register(pattern, factory)
    }
    static func handle(_ pattern: URLPattern, _ factory: @escaping URLOpenHandlerFactory) {
        Mediator.shared.navigator.handle(pattern, factory)
    }

    static func viewController(for url: URLConvertible, context: Any? = nil) -> UIViewController? {
        return Mediator.shared.navigator.viewController(for: url, context: context)
    }
    static func handler(for url: URLConvertible, context: Any? = nil) -> URLOpenHandler? {
        return Mediator.shared.navigator.handler(for: url, context: context)
    }

    @discardableResult
    static func push(_ url: URLConvertible, context: Any? = nil, from: UINavigationControllerType? = nil, animated: Bool = true) -> UIViewController? {
        return Mediator.shared.navigator.push(url, context: context, from: from, animated: animated)
    }

    
    @discardableResult
    static func push(_ viewController: UIViewController?, from: UINavigationControllerType? = nil, animated: Bool = true) -> UIViewController? {
        guard let viewController = viewController else { return nil }
        return Mediator.shared.navigator.push(viewController, from: from, animated: animated)
    }

    @discardableResult
    static func present(_ url: URLConvertible, context: Any? = nil, wrap: UINavigationController.Type? = nil, from: UIViewControllerType? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
        return Mediator.shared.navigator.present(url, context: context, wrap: wrap, from: from, animated: animated, completion: completion)
    }

    @discardableResult
    static func present(_ viewController: UIViewController, wrap: UINavigationController.Type? = nil, from: UIViewControllerType? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
        return Mediator.shared.navigator.present(viewController, wrap: wrap, from: from, animated: animated, completion: completion)
    }

    @discardableResult
    static func open(_ url: URLConvertible, context: Any? = nil) -> Bool {
        return Mediator.shared.navigator.open(url, context: context)
    }
    
    
}
