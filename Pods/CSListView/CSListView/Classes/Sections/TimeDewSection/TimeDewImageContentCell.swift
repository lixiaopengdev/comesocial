//
//  TimeDewImageContentController.swift
//  CSListView
//
//  Created by fuhao on 2023/6/16.
//

import Foundation
import IGListSwiftKit
import IGListKit
import Kingfisher


protocol TimeDewImageContentCellDelegate: AnyObject {
    func didTapImageContent(cell: TimeDewImageContentCell)
}


class TimeDewImageContentCell : UICollectionViewCell, ListBindable{
    let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let zoneView: TimeDewZoneView = {
        let view = TimeDewZoneView()
        view.top()
        return view
    }()
    
    weak var delegate: TimeDewImageContentCellDelegate? = nil
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(zoneView)
        contentView.addSubview(contentImageView)
        
        contentImageView.isUserInteractionEnabled = true
        contentImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onImageClick)))
        
        zoneView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        contentImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(28)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-28)
        }
        
    }
    
    @objc
    func onImageClick() {
        delegate?.didTapImageContent(cell: self)
    }

    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? TimeDewImageCellModel else { return }
        if viewModel.isBottom {
            zoneView.bottom()
        }else{
            zoneView.fill()
        }
        
        contentImageView.setImage(with: viewModel.ImageURL) { [weak self] result in
            guard let cell = self else { return }
            
            switch result {
            case .success(let retrieveImageResult):
                let image = retrieveImageResult.image
                let imageAspectRatio = image.size.width / image.size.height
                
                var currentImageAspectRatio:CGFloat = 2
                if cell.contentImageView.bounds.size.height > 0 {
                    currentImageAspectRatio = cell.contentImageView.bounds.size.width / cell.contentImageView.bounds.size.height
                }
                
                print("imageAspectRatio: \(imageAspectRatio), currentImageAspectRatio: \(currentImageAspectRatio)" )
                guard abs(currentImageAspectRatio - imageAspectRatio) > 0.1 else {
                    break
                }
                
                let newWidth = imageAspectRatio * 180
                print("update image constrains ,newWidth: \(newWidth)")
                cell.contentImageView.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(28)
                    make.top.equalToSuperview()
                    make.width.equalTo(newWidth)
                    make.height.equalTo(180)
                    make.bottom.equalToSuperview().offset(-10)
                }
                break
            case .failure(_): break
            }
        }
        

    }
    
    public static func forHeight() -> CGFloat {
        return 180 + 10
    }
    
}
