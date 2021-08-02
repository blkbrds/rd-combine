//
//  UIImageViewExt.swift
//  FinalCombine
//
//  Created by Quoc  Doan M. VN.Danang on 7/30/21.
//

import UIKit

extension UIImageView {

    private static var taskKey = 0
    private static var urlKey = 0
    
    private var currentTask: URLSessionTask? {
        get { return objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionTask }
        set { objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private var currentURL: URL? {
        get { return objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL }
        set { objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func loadImageAsync(with urlString: String?) {
        // Cancel prior task, if any
        weak var oldTask = currentTask
        currentTask = nil
        oldTask?.cancel()
        
        // Reset imageview's image
        self.image = nil
        
        // Allow supplying of `nil` to remove old image and then return immediately
        guard let urlString = urlString else { return }
        
        // Check cache
        if let cachedImage = ImageCache.shared.image(forKey: urlString) {
            self.image = cachedImage
            return
        }
        
        // Download
        guard let url = URL(string: urlString) else { return }
        currentURL = url
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            self?.currentTask = nil
            
            // Error handling
            if let error = error {
                if (error as NSError).domain == NSURLErrorDomain && (error as NSError).code == NSURLErrorCancelled {
                    return
                }
                return
            }
            
            guard let data = data, let downloadedImage = UIImage(data: data) else { return }
            
            ImageCache.shared.save(image: downloadedImage, forKey: urlString)
            
            if url == self?.currentURL {
                DispatchQueue.main.async {
                    self?.image = downloadedImage
                }
            }
        }
        
        // Save and start new task
        currentTask = task
        task.resume()
    }
}

class ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    private var observer: NSObjectProtocol!

    static let shared = ImageCache()

    private init() {
        // Make sure to purge cache on memory pressure
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: nil, queue: nil) { [weak self] notification in
            self?.cache.removeAllObjects()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(observer as Any)
    }

    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
