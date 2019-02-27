//
//  ImageCache.swift
//  DuckDuckSearch
//
//  Created by MCS on 2/24/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit

class ImageCache {
    // MARK: - Properties
    private let assetCache: NSCache = NSCache<NSString, UIImage>()
    
    // MARK: - Singleton
    static let shared = ImageCache()
    private init() {}
    
    func saveImageToCache(with identifier: String, for image: UIImage) {
        assetCache.setObject(image, forKey: identifier as NSString)
    }
    
    func loadImageFromCache(with identifier: String) -> UIImage? {
        return assetCache.object(forKey: identifier as NSString)
    }
    
}
