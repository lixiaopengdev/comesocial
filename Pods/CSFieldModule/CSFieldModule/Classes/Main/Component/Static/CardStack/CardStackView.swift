//
//  CardStackContainer.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/11/23.
//

import UIKit
import CSNetwork
import CSFileKit

class CardStackView: FieldBaseView {

    private(set) var selectedModel: CardModel?
    private(set) var selectedCell: UIView?
    
    let cardStackLayout = CardStackLayout()
    var stackCards = [CardModel]()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: cardStackLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CardStackCell.self, forCellWithReuseIdentifier: CardStackCell.identifer)
        collectionView.alwaysBounceHorizontal = true
        return collectionView
    }()
    
    override func initialize() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        assembly.cardManager().onCardComplete.receive(on: RunLoop.main).sink {[weak self] complete in
            self?.stackCards = self?.assembly.cardManager().cards ?? []
            self?.collectionView.reloadData()
        } receiveValue: { [weak self] result in
           
        }.store(in: &cancellableSet)
    }

}

extension CardStackView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stackCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardStackCell.identifer, for: indexPath) as! CardStackCell
        cell.updateCard(stackCards[indexPath.row])
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if cardStackLayout.fold {
            if indexPath.row == 0 {
                cardStackLayout.unfoldItems()
            }
            return
        }
        
        if !cardStackLayout.isFullScreenItem(at: indexPath) {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            return
        }
        
        
        
        let cell = collectionView.cellForItem(at: indexPath)
//        (cell as? CardStackCell)?.updateDisplay(false)

        let model = stackCards[indexPath.row]
        cardCellSelected(card: model, cell: cell)
        selectedModel = model
        selectedCell = cell
        
        
    }
    
    func cardCellSelected(card: CardModel, cell: UIView?) {
//        guard let card = stackContainer.selectedModel else { return }
        let cardDisplayView = CardDisplayView(card: card, assembly: assembly)
//        cardDisplayView.delegate = self
        var fromFrame = CGRect.zero
//        fromFrame.origin.x = view.frame.midX
        if let cell = cell {
            fromFrame = cell.convert(cell.bounds, to: cardDisplayView)
        }
        cardDisplayView.show(from: fromFrame)
    }
    
    func updateCellDisplay(type: CardDisplayView.CardDismissType, cardModel: CardModel) {
        
        let index = stackCards.firstIndex { return cardModel.id == $0.id }
        guard let index = index else {
            return
        }

        switch type {
        case .none:
            if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) {
                (cell as? CardStackCell)?.updateDisplay(true)
            }
        case .send, .apply:
            stackCards.remove(at: index)
            collectionView.performBatchUpdates {
                collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
            }
            cardStackLayout.invalidateLayout()
            
        }
    }
    
    func appendCard(cardModel: CardModel) {
        
        stackCards.append(cardModel)
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: [IndexPath(item: stackCards.count - 1, section: 0)])
        }
        cardStackLayout.invalidateLayout()
    }
}
 
