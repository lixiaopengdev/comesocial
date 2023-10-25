//
//  ImageManager.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/12/6.
//

import Kingfisher



public extension String {
    
    var asNetSource: Source? {
        return URL(string: self)?.convertToSource()
    }
    
    var asImageCachePath: String {
        return KingfisherManager.shared.cache.cachePath(forKey:self)
    }
    
    var asLocalSource: Source {
        let provider = LocalFileImageDataProvider(fileURL:URL(fileURLWithPath: asImageCachePath))
        return Source.provider(provider)
    }
    
//    private  var fullUrl: URL? {
//        return URL(string: ImageKitConfig.baseURL ?? "")?.appendingPathComponent(self)
//    }
}

