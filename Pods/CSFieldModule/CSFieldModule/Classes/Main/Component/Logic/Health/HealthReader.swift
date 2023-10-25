//
//  HealthReader.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/3/17.
//

import Foundation
//import HealthKit
import CSUtilities

class HealthReader: FieldComponent {
    
    enum HealthError: Error {
        case unknow
    }
    
    var assembly: FieldAssembly
//    private let healthStore = HKHealthStore()
    
    required init(assembly: FieldAssembly) {
        self.assembly = assembly
    }
    
    @Published var hasAuthorization: Bool = false
    
    func request() {
        
//        if !HKHealthStore.isHealthDataAvailable() {
//            hasAuthorization = false
//            return
//        }
//
//        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
//
//        healthStore.requestAuthorization(toShare: Set(), read: allTypes) { [weak self] (success, error) in
//            self?.hasAuthorization = success
//        }
    }
    
    func getStepCount(callback: @escaping Action1<Result<Double, Error>>) {
//        // 获取当天步数
//        let calendar = Calendar.current
//        let startOfDay = calendar.startOfDay(for: Date())
//        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictEndDate)
//        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
//
//        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
//
//            guard let result = result, let sum = result.sumQuantity() else {
//                DispatchQueue.main.async {
//                    callback(.failure(error ?? HealthError.unknow))
//                }
//                return
//            }
//            let steps = sum.doubleValue(for: HKUnit.count())
//            DispatchQueue.main.async {
//                callback(.success(steps))
//            }
//        }
//        
//        healthStore.execute(query)
    }
    
}
