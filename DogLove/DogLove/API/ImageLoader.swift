//
//  ImageLoader.swift
//  DogLove
//
//  Created by M. Ensar Baba on 24.11.2020.
//

import UIKit

class ImageLoader {
    
    private var task: URLSessionDownloadTask?
    private var session: URLSession?
    private var cache: NSCache<NSString, UIImage>?
    private var currentURL: String?
    
    static let shared = ImageLoader()
    
    private init() {
        session = URLSession.shared
        task = URLSessionDownloadTask()
        self.cache = NSCache()
    }
    
    func obtainImageWithPath(imagePath: String, completionHandler: @escaping (UIImage) -> ()) {
        self.currentURL = imagePath
        if let image = self.cache?.object(forKey: imagePath as NSString) {
            DispatchQueue.main.async {
                completionHandler(image)
            }
        } else {
            guard let url = URL(string: imagePath) else { return }
            task = session?.downloadTask(with: url, completionHandler: { (location, response, error) in
                
                guard let data = try? Data(contentsOf: url), let img = UIImage(data: data) else { return }
                if self.currentURL == imagePath {
                    DispatchQueue.main.async {
                        completionHandler(img)
                    }
                }
                
                self.cache?.setObject(img, forKey: imagePath as NSString)
                
            })
            task?.resume()
        }
    }
    
    func cancelLoadingImage() {
        task?.cancel()
        task = nil
    }
    
    func setPlaceholderImage() -> UIImage? {
        guard let placeholder = UIImage(named: "placeholder") else { return nil }
        return placeholder
    }
}
 
