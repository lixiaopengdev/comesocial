//
//  TimeDewViewModel.swift
//  CSLiveModule
//
//  Created by fuhao on 2023/6/25.
//

import Foundation
import Combine
import CSNetwork
import Moya
import CSListView
import CSMediator
//import CSRouter


protocol TimeDewListViewRepresentable {
    // MARK: Output
    var datas: [TimeDewViewModel] { get }
    var reloadList: AnyPublisher<Result<Void, Error>, Never> { get }
    var cellUpdate: AnyPublisher<(row: Int, model: TimeDewViewModel), Never> { get }
    
    // MARK: Input
    func attachViewEventListener(loadData: AnyPublisher<Void, Never>)
    func deleteReaction(id: UInt, label: String, onwer: String)
    func hasReaction(id: UInt, label: String, onwer: String) -> Bool
    func addReaction(id: UInt, label: String, onwer: String)
    
    func saveTimeDew(id: UInt)
    func cancleSaveTimeDew(id: UInt)
    
    func findModelById(id: UInt) -> TimeDewViewModel?

 }

class TimeDewListViewModel : TimeDewListViewRepresentable{

    private var subscriptions = Set<AnyCancellable>()
    
//    private var tableDataSource: [HomeTableCellType] = [HomeTableCellType]()
    private var allTimeDew = [TimeDewViewModel]()
    
    
    
    // MARK: Input
    private var loadData: AnyPublisher<Void, Never> = PassthroughSubject<Void, Never>().eraseToAnyPublisher()
    
    
    // MARK: Output
    var datas: [TimeDewViewModel] {
        return allTimeDew
    }
    var reloadList: AnyPublisher<Result<Void, Error>, Never> {
        reloadListSubject.eraseToAnyPublisher()
    }
    
    var cellUpdate: AnyPublisher<(row: Int, model: TimeDewViewModel), Never> {
        cellUpdateSubject.eraseToAnyPublisher()
    }
    
    
    
    
    private let cellUpdateSubject = PassthroughSubject<(row: Int, model: TimeDewViewModel), Never>()
    private let reloadListSubject = PassthroughSubject<Result<Void, Error>, Never>()
    
    init() { }
    
    
    func attachViewEventListener(loadData: AnyPublisher<Void, Never>) {
        self.loadData = loadData
        self.loadData
            .throttle(for: .seconds(5), scheduler: DispatchQueue.global(), latest: true)
            .setFailureType(to: NetworkError.self)
            .handleEvents(receiveOutput: { [weak self] _ in
//                self?.allTimeDew.removeAll()
            })
            .flatMap { _ -> AnyPublisher<[TimeDewViewModel], NetworkError> in
                return Network.requestPublisher(LifeFlowService.realTimeState)
                    .mapModel(LifeFlowModel.self)
                    .map { lifeflowmodel in
                        
                        
                        return lifeflowmodel.lifeFlow.map { model in
                            
                            let timeDewReactionCellModels:[TimeDewReactionCellModel] = model.reactions.compactMap { (key:String, value:[LifeFlowReactionsModel]) in
                                let users = value.compactMap({$0.name})
                                return TimeDewReactionCellModel(reactionLabel: key, reactionUsers: users)
                            }.sorted { $0.reactionLabel < $1.reactionLabel }
                            
                            
                            return TimeDewViewModel(id: UInt(model.id),
                                                     type: model.type,
                                                     icon: model.onwerThumb,
                                                     title: model.title,
                                                     timeStamp: model.timeStamp,
                                                     content: model.content,
                                                     imageContent: model.imageUrl,
                                                     reactions: timeDewReactionCellModels,
                                                     isSave: model.is_saved,
                                                     fieldID: model.fieldID,
                                                     onwerID: model.onwerId,
                                                     members: model.members,
                                                     members_thumbs: model.members_thumbs)
                        }
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    print("receiveCompletion")
                    if case let .failure(error) = completion {
                        self?.reloadListSubject.send(.failure(error))
                    }
                },
                receiveValue: { [weak self] items in
                    self?.allTimeDew.removeAll()
                    self?.allTimeDew.append(contentsOf: items)
                    self?.reloadListSubject.send(.success(()))
            })
            .store(in: &subscriptions)
    }
    
    
    func deleteReaction(id: UInt, label: String, onwer: String){
        guard let index = datas.firstIndex(where: { $0.id == id }) else { return }
        let viewModel = datas[index]
        if viewModel.deleteReaction(label: label, onwer: onwer) {
            Mediator.resolve(LiveService.TimeDewService.self)?.doReactionTimeDew(id: Int(viewModel.id), type: label, editHandle: 0)
//            Router.shared.open(Router.Live.doReactionTimeDewPath(id: Int(viewModel.id), type: label, edit: 0))
            
            cellUpdateSubject.send((row: index, model: viewModel))
        }
    }
    
    func hasReaction(id: UInt, label: String, onwer: String) -> Bool {
        guard let viewModel = findModelById(id: id) else { return false}
        return viewModel.hasReaction(label: label, onwer: onwer)
    }
    
    func addReaction(id: UInt, label: String, onwer: String){
        guard let index = datas.firstIndex(where: { $0.id == id }) else { return }
        let viewModel = datas[index]
        
        if viewModel.addReaction(label: label, onwer: onwer) {
            Mediator.resolve(LiveService.TimeDewService.self)?.doReactionTimeDew(id: Int(viewModel.id), type: label, editHandle: 1)
//            Router.shared.open(Router.Live.doReactionTimeDewPath(id: Int(viewModel.id), type: label, edit: 1))
            cellUpdateSubject.send((row: index, model: viewModel))
        }
    }
    
    func saveTimeDew(id: UInt) {
        guard let viewModel = findModelById(id: id) else { return}
        viewModel.isSave = true
    }
    
    func cancleSaveTimeDew(id: UInt) {
        guard let viewModel = findModelById(id: id) else { return}
        viewModel.isSave = false
    }
    
    func findModelById(id: UInt) -> TimeDewViewModel? {
        return datas.first(where: { $0.id == id })
    }
    
    
}
