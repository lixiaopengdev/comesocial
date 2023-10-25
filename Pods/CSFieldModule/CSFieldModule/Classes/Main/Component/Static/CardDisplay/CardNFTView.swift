//
//  NFTBuildView.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/12/8.
//

import UIKit
import CSUtilities
//import ComeSocialNetwork

class CardNFTView: CardContentView {
    
    let addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "card_nft_add"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    let nameField: TextField = {
        let field = TextField()
        field.textColor = .white
        field.text = "Unnamed"
        field.maxCharactersLimit = 10
        field.font = .name(.avenirNextBold, size: 23)
        return field
    }()
    
    let seriesLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: 0xe3e3e3, alpha: 0.4)
        label.font = .name(.avenirNextRegular, size: 12)
        label.text = "Memory Series"
        return label
    }()
    
    let lockImageView = UIImageView(image: UIImage(named: "card_nft_unlock"))
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .name(.sourceCodeProRegular, size: 9)
        label.numberOfLines = 2
        label.textAlignment = .right
        label.text = Date().string(withFormat: "yyyy.MM.dd") + "\n@come.social"
        return label
    }()
    
    
    //    private var selectedImage: UIImage?
    
    let cardContext: CardNFTContext
    
    init(cardContext: CardNFTContext) {
        self.cardContext = cardContext
        super.init(frame: .zero)
        backgroundColor = .black
        let width = Device.UI.screenWidth - CardDisplayView.CardStyle.large.margin * 2
        layerCornerRadius = width * 0.1
        
        addButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        
        addSubview(addButton)
        addSubview(nameField)
        addSubview(lockImageView)
        addSubview(seriesLabel)
        addSubview(infoLabel)
        
        addButton.snp.makeConstraints { make in
            make.left.top.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(addButton.snp.width).multipliedBy(5/4.5)
        }
        nameField.snp.makeConstraints { make in
            make.left.equalTo(addButton.snp.left)
            make.top.equalTo(addButton.snp.bottom).offset(13)
            make.right.equalTo(-70)
        }
        seriesLabel.snp.makeConstraints { make in
            make.left.equalTo(addButton.snp.left)
            make.top.equalTo(nameField.snp.bottom).offset(5)
            make.right.equalTo(-70)
        }
        lockImageView.snp.makeConstraints { make in
            make.right.equalTo(addButton.snp.right)
            make.centerY.equalTo(nameField.snp.centerY)
            make.size.equalTo(CGSize(width: 43, height: 15.4))
        }
        infoLabel.snp.makeConstraints { make in
            make.right.equalTo(addButton.snp.right)
            make.top.equalTo(lockImageView.snp.bottom).offset(29)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func addImage() {
        showImagePicker()
        
    }
    
    private func showImagePicker() {
        
//        var config = YPImagePickerConfiguration()
//        config.showsPhotoFilters = false
//        config.startOnScreen = .library
//        config.screens = [.library, .photo]
//        let picker = YPImagePicker(configuration: config)
//        
//        picker.didFinishPicking {[weak picker, weak self] items, cancelled in
//            if cancelled {
//                picker?.dismiss(animated: true)
//                return
//            }
//            if case let .photo(p: medioPhoto) =  items.first {
//                let size = medioPhoto.image.size
//                let targetSize: CGSize
//                if size.width / size.height > 0.9 {
//                    targetSize = CGSize(width: size.height * 0.9, height: size.height)
//                } else {
//                    targetSize = CGSize(width: size.width, height: size.width * 10 / 9 )
//                }
//                let rect = CGRect(origin: CGPoint(x: (size.width - targetSize.width) / 2, y: (size.height - targetSize.height) / 2), size: targetSize)
//                
//                let newImage = medioPhoto.image.cropped(to: rect)
//                self?.changeSelecteImage(newImage)
//            }
//            picker?.dismiss(animated: true)
//        }
//        
//        parentViewController?.present(picker, animated: true)
    }
    
    func changeSelecteImage(_ image: UIImage) {
        cardContext.image =  image
        addButton.setImage(image, for: .normal)
        addButton.layerCornerRadius = addButton.frame.height * 0.05
        lockImageView.image = UIImage(named: "card_nft_lock")
    }
    
    override func willApply() -> CardContext {
        cardContext.title = nameField.text ?? ""
        cardContext.subTitle = seriesLabel.text ?? ""
        cardContext.time = infoLabel.text ?? ""
        return cardContext
    }
    
}

extension CardNFTView {
    static func defaultNFTView(context: CardNFTContext) -> UIImage? {
        let nftView = CardNFTView(cardContext: context)
        let view = UIView(frame: CGRect(origin: CGPoint.zero, size: Device.UI.screenSize))
        view.addSubview(nftView)
        nftView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.size.equalTo(CardDisplayView.CardStyle.large.size)
        }
        nftView.setNeedsLayout()
        nftView.layoutIfNeeded()
        return nftView.screenshot
    }
}
