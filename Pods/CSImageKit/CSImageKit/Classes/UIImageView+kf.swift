//
//  UIImageView+kf.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/12/6.
//

import Kingfisher


public extension UIImageView {
    
    @discardableResult
    func setAvatar(with source: String?) -> DownloadTask? {
        let source = source?.asNetSource
        return self.kf.setImage(with: source, placeholder: nil, options: [], completionHandler: nil)
        
    }
    
    @discardableResult
    func setImage(with source: String?,
                  placeholder: Placeholder? = nil,
                  options: KingfisherOptionsInfo? = nil,
                  completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {
        let source = source?.asNetSource 
        return self.kf.setImage(with: source, placeholder: placeholder, options: options, completionHandler: completionHandler)
        
    }
    
    @discardableResult
    func setCard(with source: String?,
                  placeholder: Placeholder? = nil,
                  options: KingfisherOptionsInfo? = nil,
                  completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {
        guard let source = source?.asNetSource else {
            return nil
        }
        return self.kf.setImage(with: source, placeholder: placeholder, options: [.processor(RoundCornerImageProcessor(radius: Radius.widthFraction(0.1))), .cacheSerializer(FormatIndicatedCacheSerializer.png)], completionHandler: completionHandler)
        
    }
    
    @discardableResult
    func setImage(with source: Source?,
                  placeholder: Placeholder? = nil,
                  options: KingfisherOptionsInfo? = nil,
                  completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {
        
        return self.kf.setImage(with: source, placeholder: placeholder, options: [.processor(RoundCornerImageProcessor(radius: Radius.widthFraction(0.1))), .cacheSerializer(FormatIndicatedCacheSerializer.png)], completionHandler: completionHandler)
        
    }
    
}
