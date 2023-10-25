//
//  Network+Transform.swift
//  CSNetwork
//
//  Created by 于冬冬 on 2023/6/25.
//

import Foundation
import Moya
import ObjectMapper

public extension Network {
    @discardableResult
    static func request<Transform: TransformType>(_ target: TargetType,
                                                  transform: Transform = AnyTransform(),
                                                  callbackQueue: DispatchQueue? = .none,
                                                  progress: ProgressBlock? = .none,
                                                  success: ((Transform.Object) -> Void)?,
                                                  failure: FailureBlock? = .none) -> Moya.Cancellable {
        return getPrivode(target).request(MultiTarget(target)) { result in
            let transformResult = transform.transformFromResult(result)
            switch transformResult {
            case .success(let value):
                success?(value)
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    @discardableResult
    static func request<Transform: TransformType>(_ target: TargetType,
                                                  transform: Transform = AnyTransform(),
                                                  callbackQueue: DispatchQueue? = .none,
                                                  progress: ProgressBlock? = .none,
                                                  completion: ((Result<Transform.Object, NetworkError>) -> Void)?) -> Moya.Cancellable {
        return getPrivode(target).request(MultiTarget(target)) { result in
            let transformResult = transform.transformFromResult(result)
            completion?(transformResult)
        }
    }
}

public protocol TransformType {
    associatedtype Object
    func transformFromResult(_ value: Result<Moya.Response, MoyaError>) -> Result<Object, NetworkError>
}

public class AnyTransform: TransformType {
    public init() {}

    public func transformFromResult(_ value: Result<Moya.Response, Moya.MoyaError>) -> Result<Any, NetworkError> {
        return Network.transform(result: value)
    }
}

public class TypeTransform<T>: TransformType {
    public init() {}

    public func transformFromResult(_ value: Result<Moya.Response, Moya.MoyaError>) -> Result<T, NetworkError> {
        let result = Network.transform(result: value)
        return result.flatMap { anyValue in
            if let value = anyValue as? T {
                return .success(value)
            }
            return .failure(.undefined(-1, "map error"))
        }
    }
}

public class ModelTransform<T: Mappable>: TransformType {
    public init() {}
    public func transformFromResult(_ value: Result<Moya.Response, Moya.MoyaError>) -> Result<T, NetworkError> {
        let result = Network.transform(result: value)
        return result.flatMap { anyValue in
            if let value = Mapper<T>().map(JSONObject: anyValue) {
                return .success(value)
            }
            return .failure(.undefined(-1, "map error"))
        }
    }
}

public class ModelsTransform<T: Mappable>: TransformType {
    public init() {}

    public func transformFromResult(_ value: Result<Moya.Response, Moya.MoyaError>) -> Result<[T], NetworkError> {
        let result = Network.transform(result: value)
        return result.flatMap { anyValue in
            if let values = Mapper<T>().mapArray(JSONObject: anyValue) {
                return .success(values)
            }
            return .failure(.undefined(-1, "map error"))
        }
    }
}

