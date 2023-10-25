//
//  Utlis.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/5/27.
//

import Foundation
import Combine
import CSFileKit

enum Utlis {
    
    static func saveBufferToServe(pixelBuffer: CVPixelBuffer, orientation: UIImage.Orientation) -> AnyPublisher<String, Error> {
        return Future { promise in
            Task {
                do {
                    let image = UIImage(pixelBuffer: pixelBuffer, orientation: orientation)
                    let localUrl = try await FileTask.saveImage(image: image)
                    let serveUrl = try await UploadTask.uploadImage(path: localUrl)
                    promise(.success(serveUrl))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .subscribe(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
