//
//  UIImageView+Extension.swift
//  DogLove
//
//  Created by M. Ensar Baba on 14.08.2021.
//

import UIKit

extension UIImageView {

    private static var taskKey: UInt8 = 0
    private static var urlKey: UInt8  = 0

    private var currentTask: URLSessionTask? {
        get { associatedObject(base: self, key: &UIImageView.taskKey) }
        set { associateObject(base: self, key: &UIImageView.taskKey, value: newValue) }
    }

    private var currentURL: URL? {
        get { associatedObject(base: self, key: &UIImageView.urlKey) }
        set { associateObject(base: self, key: &UIImageView.urlKey, value: newValue) }
    }

    func loadImageAsync(with urlString: String?) {
        self.startSpinner()
        
        // cancel prior task, if any
        weak var oldTask = currentTask
        currentTask = nil
        oldTask?.cancel()

        // reset imageview's image

        self.image = nil

        // allow supplying of `nil` to remove old image and then return immediately

        guard let urlString = urlString else { self.stopSpinner(); return }

        // check cache

        if let cachedImage = ImageCache.shared.image(forKey: urlString) {
            self.image = cachedImage
            self.stopSpinner()
            return
        }

        // download

        guard let url = URL(string: urlString) else { self.stopSpinner(); return }
        currentURL = url
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            self?.currentTask = nil

            //error handling

            if let error = error {
                // don't bother reporting cancelation errors

                if (error as NSError).domain == NSURLErrorDomain && (error as NSError).code == NSURLErrorCancelled {
                    return
                }
                self?.stopSpinner()
                print(error)
                return
            }

            guard let data = data, let downloadedImage = UIImage(data: data) else {
                print("unable to extract image")
                self?.stopSpinner()
                return
            }

            ImageCache.shared.save(image: downloadedImage, forKey: urlString)

            if url == self?.currentURL {
                DispatchQueue.main.async {
                    self?.stopSpinner()
                    self?.image = downloadedImage
                }
            }
        }

        // save and start new task

        currentTask = task
        task.resume()
    }

}
