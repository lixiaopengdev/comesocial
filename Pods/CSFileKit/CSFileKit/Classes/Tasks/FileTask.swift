//
//  FileTask.swift
//  CSFileKit
//
//  Created by 于冬冬 on 2023/3/9.
//

import UIKit
import FileKit
import Combine

public struct FileTask {
    
    public static func saveImage(image: UIImage?) async throws -> URL {
        guard let image = image else {
            throw FileError.upload("image is nil")
        }
        guard let imageData =  image.jpegData(compressionQuality: 0.7) else {
            throw FileError.upload("imageData is nil")
        }
        let key = UUID().uuidString
        let directory = Path.tmpImage
        try directory.createDirectory()
        let path = directory + "\(key).jpg"
        try imageData.write(to: path)
        return path.url
    }
    
    public static func saveImage(image: UIImage)  -> AnyPublisher<URL, FileError> {
        
        return Future<URL, FileError> { promise in
            DispatchQueue.global().async {
                guard let imageData = image.jpegData(compressionQuality: 0.7) else {
                    promise(.failure(FileError.image("image data nil")))
                    return
                }
                do {
                    let key = UUID().uuidString
                    let directory = Path.tmpImage
                    try directory.createDirectory()
                    let path = directory + "\(key).jpg"
                    try imageData.write(to: path)
                    promise(.success(path.url))
                } catch {
                    promise(.failure(FileError.system(error)))
                }
            }
        }.subscribe(on: RunLoop.main).eraseToAnyPublisher()
        
    }
    
}
