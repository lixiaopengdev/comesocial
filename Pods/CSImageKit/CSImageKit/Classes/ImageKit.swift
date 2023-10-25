//
//  ImageKit.swift
//  CSImageKit
//
//  Created by 于冬冬 on 2023/1/4.
//

import Foundation
import Kingfisher

public class ImageKit {
    
    public static let shared = ImageKit()
    
    @discardableResult
    public func retrieveImage(
        with source: Source,
        options: KingfisherOptionsInfo? = nil,
        progressBlock: DownloadProgressBlock? = nil,
        downloadTaskUpdated: DownloadTaskUpdatedBlock? = nil,
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)?) -> DownloadTask?
    {
        return KingfisherManager.shared.retrieveImage(with: source, options: [.processor(RoundCornerImageProcessor(radius: Radius.widthFraction(0.1))), .cacheSerializer(FormatIndicatedCacheSerializer.png)], progressBlock: progressBlock, downloadTaskUpdated: downloadTaskUpdated, completionHandler: completionHandler)
    }
    
    @discardableResult
    public func retrieveImage(
        with source: String?,
        options: KingfisherOptionsInfo? = nil,
        progressBlock: DownloadProgressBlock? = nil,
        downloadTaskUpdated: DownloadTaskUpdatedBlock? = nil,
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)?) -> DownloadTask?
    {
        guard let source = source?.asNetSource else {
            return nil
        }
        return KingfisherManager.shared.retrieveImage(with: source, options: [.processor(RoundCornerImageProcessor(radius: Radius.widthFraction(0.1))), .cacheSerializer(FormatIndicatedCacheSerializer.png)], progressBlock: progressBlock, downloadTaskUpdated: downloadTaskUpdated, completionHandler: completionHandler)
    }
    
    //    public func catchCard(url: String) {
    //        guard let source = url.asSource else { return }
    //        let options:KingfisherOptionsInfo = [
    //            .processor(RoundCornerImageProcessor(radius: Radius.widthFraction(0.1))),
    //            .cacheSerializer(FormatIndicatedCacheSerializer.png),
    //            .backgroundDecode,
    //            .downloadPriority(URLSessionTask.lowPriority)
    //        ]
    //        KingfisherManager.shared.retrieveImage(with: source, options: options, completionHandler: nil)
    //
    //    }
    //
    public func cacheCustomImage(image: UIImage, key: String) {
        let parsedOptionsInfo = KingfisherParsedOptionsInfo([.backgroundDecode, .cacheSerializer(FormatIndicatedCacheSerializer.png)])
        KingfisherManager.shared.cache.store(image, forKey: key, options: parsedOptionsInfo);
    }
    
    public func cacheImage(image: UIImage, key: String, completion: ((Bool) -> Void)?) {
        KingfisherManager.shared.cache.store(image, forKey: key) { result in
           let success = (try? result.diskCacheResult.get()) != nil
            completion?(success)
        }
    }
    
    
}
