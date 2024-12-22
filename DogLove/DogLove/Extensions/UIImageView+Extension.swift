//
//  UIImageView+Extension.swift
//  DogLove
//
//  Created by M. Ensar Baba on 14.08.2021.
//
import UIKit

@MainActor
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

    func loadImageAsync(with urlString: String?) async {
        startSpinner()

        // Cancel prior task, if any
        if let oldTask = currentTask {
            oldTask.cancel()
            currentTask = nil
        }

        // Reset imageview's image
        self.image = nil

        // Allow supplying of `nil` to remove old image and then return immediately
        guard let urlString = urlString else {
            stopSpinner()
            return
        }

        // Check cache
        if let cachedImage = await ImageCache.shared.image(forKey: urlString) {
            self.image = cachedImage
            stopSpinner()
            return
        }

        // Download
        guard let url = URL(string: urlString) else {
            stopSpinner()
            return
        }

        currentURL = url

        do {
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))

            guard let downloadedImage = UIImage(data: data) else {
                debugPrint("unable to extract image")
                stopSpinner()
                return
            }

            await ImageCache.shared.save(image: downloadedImage, forKey: urlString)

            // Check if the URL hasn't changed during download
            if url == currentURL {
                self.image = downloadedImage
                stopSpinner()
            }

        } catch let error as NSError {
            // Don't bother reporting cancelation errors
            if error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
                return
            }
            debugPrint(error)
            stopSpinner()
        }
    }
}
