//
//  ImagePicker.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/5/24.
//

import Foundation
import YPImagePicker
import Photos

public class ImagePicker {
    
    public class func configPicker(callback: @escaping (UIImage?) -> Void) -> UIViewController {
        
        var config = YPImagePickerConfiguration()
        config.showsPhotoFilters = false
        config.startOnScreen = .library
        config.screens = [.library, .photo]
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking {[weak picker] items, cancelled in
            if cancelled {
                picker?.dismiss(animated: true)
                callback(nil)
                return
            }
            if case let .photo(p: medioPhoto) =  items.first {
                callback(medioPhoto.image)
            }
            picker?.dismiss(animated: true)
        }
        return picker
    }
}
