//
//  ImageCache.swift
//  LoveSick2
//
//  Created by marky RE on 10/3/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
class ImageCache {
    static let imageCache = AutoPurgingImageCache(
        memoryCapacity: UInt64(100).megabytes(),
        preferredMemoryUsageAfterPurge: UInt64(60).megabytes()
    )
    static func cache(_ image: Image, for url: String) {
        imageCache.add(image, withIdentifier: url)
    }
    
    static func cachedImage(for url: String) -> Image? {
        return imageCache.image(withIdentifier: url)
    }
}
