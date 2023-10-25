//
//  TimeDewSectionController.swift
//  CSListView
//
//  Created by 于冬冬 on 2023/6/13.
//


import IGListSwiftKit
import IGListKit

public protocol TimeDewSectionDelegate: AnyObject {
    func onCellClick(model: TimeDewViewModel)
    func onAvatarImageClick(model: TimeDewViewModel)
    func onImageContentClick(model: TimeDewViewModel, image: UIImage)
    func onReactionClick(model: TimeDewViewModel,reactionLabel: String)
}

final public class TimeDewSectionController: ListBindingSectionController<TimeDewViewModel>,ListBindingSectionControllerDataSource, ListBindingSectionControllerSelectionDelegate{
    public weak var timeDewDelegate: TimeDewSectionDelegate? = nil
    
    
    
    public override init() {
        super.init()
        dataSource = self
        selectionDelegate = self
    }

    public override func didUpdate(to object: Any) {
        super.didUpdate(to: object)
    }


    public func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {

        guard let object = object as? TimeDewViewModel else { fatalError() }
        
        var results: [ListDiffable] = [
            TimeDewTitleCellModel(icon: object.icon!, title: object.title!, timeStamp: convertToTimeStr(timeStamp: object.timeStamp)),
            TimeDewTextContentCellModel(content: object.content)
        ]

        if let imageContent = object.imageContent {
            let imageCellModel = TimeDewImageCellModel(ImageURL: imageContent)
            results.append(imageCellModel)
        }
        
        let reactions = (object.reactions?.filter({ model in
            !model.reactionUsers.isEmpty
        }) ?? [TimeDewReactionCellModel]()).map { model in
            TimeDewReactionCellModel(reactionLabel: model.reactionLabel, reactionUsers: model.reactionUsers)
        }
        
        results.append(contentsOf: reactions)
        
        if let lastCell = results.last! as? TimeDewBaseCellModel {
            lastCell.isBottom = true
        }
        
        results.append(TimeDewSectionSpaceViewModel())
        
        
        return results 
    }

    public func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
        switch viewModel {
        case is TimeDewTitleCellModel:
            let cell = collectionContext.dequeueReusableCell(for: self, at: index) as TimeDewTitleCell
            cell.delegate = self
            return cell
        case is TimeDewTextContentCellModel:
            let cell = collectionContext.dequeueReusableCell(for: self, at: index) as TimeDewTextContentCell
            return cell
        case is TimeDewImageCellModel:
            let cell = collectionContext.dequeueReusableCell(for: self, at: index) as TimeDewImageContentCell
            cell.delegate = self
            return cell
        case is TimeDewReactionCellModel:
            let cell = collectionContext.dequeueReusableCell(for: self, at: index) as TimeDewReactionCell
            cell.delegate = self
            return cell
        default:
            let cell = collectionContext.dequeueReusableCell(for: self, at: index) as TimeDewSectionSpaceCell
            return cell
        }
    }

    public func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        guard let width = collectionContext?.containerSize.width else { fatalError() }

        let height: CGFloat
        switch viewModel {
        case is TimeDewTitleCellModel:
            height = 54
        case is TimeDewTextContentCellModel:
            height = TimeDewTextContentCell.forHeight(width: width, text: (viewModel as! TimeDewTextContentCellModel).content)
        case is TimeDewImageCellModel:
            height = TimeDewImageContentCell.forHeight()
        case is TimeDewReactionCellModel:
            height = TimeDewReactionCell.forHeight(width: width, users: (viewModel as! TimeDewReactionCellModel).reactionUsers)
        default: height = 10
        }
        
        
        return CGSize(width: width, height: height)
    }



    public func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, didSelectItemAt index: Int, viewModel: Any) {
        print("didSelectItemAt index: \(index)")
        guard let object = object else { return }
        timeDewDelegate?.onCellClick(model: object)
    }

    public func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, didDeselectItemAt index: Int, viewModel: Any) {
        print("didDeselectItemAt index: \(index)")
    }

    public func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, didHighlightItemAt index: Int, viewModel: Any) {
    }

    public func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, didUnhighlightItemAt index: Int, viewModel: Any) {
        print("didUnhighlightItemAt index: \(index)")
    }
    
    
    func convertToTimeStr(timeStamp: Int64?) -> String {
        guard let timeStamp = timeStamp else {
            return ""
        }
        let dataFormat = DateFormatter()
        dataFormat.dateFormat = "HH:mm"
        let date = Date(timeIntervalSince1970: TimeInterval(Double(timeStamp)*0.001))
        let timeStr = dataFormat.string(from: date)
        return timeStr
    }
}

extension TimeDewSectionController : TimeDewTitleCellDelegate {
    func didTapAvatarImage(cell: TimeDewTitleCell) {
        print("TimeDewTitleCell Click")
        guard let object = object else { return }
        timeDewDelegate?.onAvatarImageClick(model: object)
    }
}

extension TimeDewSectionController : TimeDewImageContentCellDelegate {
    func didTapImageContent(cell: TimeDewImageContentCell) {
        print("TimeDewImageContentCell Click")
        guard let object = object else { return }
        guard let image = cell.contentImageView.image else { return }
        
        timeDewDelegate?.onImageContentClick(model: object, image: image)
    }
}

extension TimeDewSectionController : TimeDewReactionCellDelegate {
    func didTapReaction(cell: TimeDewReactionCell) {
        guard let object = object else { return }
        guard let reactionLabel = cell.reactionLabel else { return }
        
        timeDewDelegate?.onReactionClick(model: object, reactionLabel: reactionLabel)
    }
}
