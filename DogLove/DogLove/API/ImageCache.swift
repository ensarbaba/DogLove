//
//  ImageCache.swift
//  DogLove
//
//  Created by M. Ensar Baba on 14.08.2021.
//

import UIKit
class ImageCache {
    public let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = 50*1024*1024
        return cache
    }()
    
    
    static let shared = ImageCache()
    
    private init() {}

    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
