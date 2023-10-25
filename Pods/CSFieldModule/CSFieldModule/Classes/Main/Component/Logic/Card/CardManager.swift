//
//  CardManager.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/10.
//

import Foundation
import JSEngineKit
import FileKit
import CSNetwork
import CSFileKit
import Combine

class CardManager: FieldComponent {
    var assembly: FieldAssembly
    var cards: [CardModel] = []
    var cardFiles: [String: CardFile] = [:]
    var onCardComplete: CurrentValueSubject = CurrentValueSubject<Bool, FieldError>(false)
    required init(assembly: FieldAssembly) {
        self.assembly = assembly
    }
    
    func initialize() {
        
        Network.request(FieldService.cards, transform: ModelsTransform<CardModel>()) { [weak self] models in
            self?.cards = models
            self?.setupCardFile()
        }

    }
    
    func bootstrap() {
        
    }
    
    func setupCardFile() {
        Task {
//            guard let cards = self.cards else { return }
            do {
                var cardFiles: [String: CardFile] = [:]
                for card in cards {
                    if let url = URL(string: card.scriptUrl ?? "") {
                        let file = CardFile(url: url)
                        try await file.loadCard()
                        cardFiles[card.idString] = file
                    }
                }
                let newFiles = cardFiles
                await MainActor.run {
                    self.cardFiles = newFiles
                    onCardComplete.send(completion: .finished)
                }
                
            } catch {
                await MainActor.run {
                    self.onCardComplete.send(completion:.failure(.custom("card init fail")))
                }
            }
            
        }
        
    }
    
    func useCard(_ card: CardModel) {
        
        guard let file = cardFiles[card.idString] else {
            assertionFailure("card lose")
            return
        }
        var result: [AnyHashable : Any]?
        YZJSEngineManager.shared().getJsSettings(withInstanceId: card.idString, filePath: file.jsFile) { data in
            result = (data as? JSValue)?.toDictionary()
        }
        
        YZJSEngineManager.shared().setJsSettingsWithInstanceId(card.idString, arr: result!) { data in
            
        }
        
        PropertiesMessage(assembly: assembly).useJs(card: card)
        YZJSEngineManager.shared().callJSMethod("applyAction", instanceId: card.idString, args: nil) { data in
            
        }
        
        
    }
    
    
    func syncJs(name: String) {
        guard let file = cardFiles[name] else {
//            assertionFailure("card lose")
            return
        }
        YZJSEngineManager.shared().registerJSPath(file.jsDirectory, instanceId: name)
        
    }
    

    deinit {
        print("CardManager deinit")
    }
}
