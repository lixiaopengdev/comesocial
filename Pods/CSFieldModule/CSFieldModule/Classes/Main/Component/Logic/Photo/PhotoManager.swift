//
//  PhotoManager.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/3/17.
//

import Foundation
import YPImagePicker
import CSUtilities

class PhotoManager: FieldComponent {
    var assembly: FieldAssembly
    
    required init(assembly: FieldAssembly) {
        self.assembly = assembly
    }
    
    func showImagePicker(callback: @escaping Action1<UIImage?>) {
        
        var config = YPImagePickerConfiguration()
        config.showsPhotoFilters = false
        config.startOnScreen = .library
        config.screens = [.library, .photo]
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking {[weak picker, weak self] items, cancelled in
            if cancelled {
                picker?.dismiss(animated: true)
                callback(nil)
                return
            }
            if case let .photo(p: medioPhoto) =  items.first {
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
                callback(medioPhoto.image)
            }
            picker?.dismiss(animated: true)
        }
        
        assembly.viewController?.present(picker, animated: true)
    }
}
