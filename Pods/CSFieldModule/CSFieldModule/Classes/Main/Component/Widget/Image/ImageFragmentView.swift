//
//  ImageFragmentView.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/3/16.
//

import UIKit
import CSImageKit
import Kingfisher

class ImageFragmentView: WidgetFragmentView {
    
    let imageView = UIImageView()
    var imageFragment: ImageFragment {
        return fragment as! ImageFragment
    }
    override func initialize() {
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layerCornerRadius = 6
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageFragment.$url.removeDuplicates().sink {[weak self] url in
            self?.imageView.setImage(with: url, options: [.processor(RoundCornerImageProcessor(radius: Radius.widthFraction(0.05))), .cacheSerializer(FormatIndicatedCacheSerializer.png)])
        }.store(in: &cancellableSet)
        
        imageView.publisher(for: \.image).map({ $0 == nil }).sink { [weak self] empty in
            self?.imageView.backgroundColor = empty ? UIColor(hex: 0x1b1b1b) : nil
        }.store(in: &cancellableSet)
    }
    

}
