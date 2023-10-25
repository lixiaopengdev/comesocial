//
//  Publisher.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/2/20.
//

import Combine

public extension Publisher where Failure == Never {
    func weakAssign<T: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<T, Output>,
        on object: T
    ) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}

public extension Publisher {
     func sink(success: @escaping ((Self.Output) -> Void), failure: @escaping ((Self.Failure) -> Void)) -> AnyCancellable {
         sink { completion in
             if case let .failure(error) = completion {
                 failure(error)
             }
         } receiveValue: { value in
             success(value)
         }
    }
    
    func sinkSuccess(_ success: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
        sink { _ in
            
        } receiveValue: { value in
            success(value)
        }
   }
    
    func sinkFailure(_ failure: @escaping ((Self.Failure) -> Void)) -> AnyCancellable {
        sink { completion in
            if case let .failure(error) = completion {
                failure(error)
            }
        } receiveValue: {_ in
            
        }
   }
    
    
    func sink(completion: @escaping ((Result<Self.Output, Failure>) -> Void)) -> AnyCancellable {
        sink { com in
            if case let .failure(error) = com {
                completion(.failure(error))
            }
        } receiveValue: { value in
            completion(.success(value))
        }
   }
}
