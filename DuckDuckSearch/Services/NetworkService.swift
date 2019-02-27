//
//  NetworkService.swift
//  DuckDuckSearch
//
//  Created by MCS on 2/24/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit

class NetworkService {
    func performSearch(for term: URL?, completion: @escaping (Data?) -> Void) {
        guard let urlDestination: URL = term else { completion(nil); return }
        
        URLSession.shared.dataTask(with: urlDestination) { (data, response, error) in
            if error != nil {
                completion(nil)
                return
            }
            
            guard let jsonResult = data else {
                completion(nil)
                return
            }
            
            completion(jsonResult)
        }.resume()
    }
    
    func getImage(for link: String, completion: @escaping (UIImage?) -> Void) {
        if let image = ImageCache.shared.loadImageFromCache(with: link) {
            completion(image)
        } else {
            guard let imageURL: URL = URL(string: link) else { completion(nil); return }
            
            URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                if error != nil {
                    completion(nil)
                    return
                }
                
                guard let imageData = data else {
                    completion(nil)
                    return
                }
                
                if let image = UIImage(data: imageData) {
                    ImageCache.shared.saveImageToCache(with: link, for: image)
                    
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }.resume()
        }
    }
}
