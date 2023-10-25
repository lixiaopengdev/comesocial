////
////  RobotViewModel.swift
////  CSLiveModule
////
////  Created by fuhao on 2023/6/12.
////
//
import Foundation
import Combine
import CSRobotView


enum RobotViewState {
    case loading
    case layouting
    case loaded
    case hide
}


protocol RobotViewRepresentable {
    // MARK: Output
    var stateChange: AnyPublisher<RobotViewState, Never> { get }

    // MARK: Input
    func stateChange(state: RobotViewState)
 }

class RobotViewModel : RobotViewRepresentable{
    
    
    var stateChange: AnyPublisher<RobotViewState, Never> {
        stateChangeSubject.eraseToAnyPublisher()
    }
    private let stateChangeSubject = PassthroughSubject<RobotViewState, Never>()
    
    func stateChange(state: RobotViewState) {
        stateChangeSubject.send(state)
    }
    
    
}
