//
//  ImageLoader.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 12/02/24.
//

import SwiftUI
import AVFoundation

class ImageLoader {
    var cache = NSCache<AnyObject, AnyObject>()
    class var sharedLoader : ImageLoader {
        struct Static {
            static let instance : ImageLoader = ImageLoader()
        }
        return Static.instance
    }
    
    func imageForUrl(_ urlString: String, completionHandler:@escaping (_ image: UIImage?, _ url: String) -> ()) {
        let image: UIImage? = self.cache.object(forKey: urlString as AnyObject) as? UIImage
        if image != nil {
            DispatchQueue.main.async(execute: { () -> Void in
                completionHandler(image, urlString)
            })
            return
        }
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async(execute: { () -> Void in
                let staticImg = UIImage(named: urlString)
                completionHandler(staticImg, urlString)
            })
            return
        }
        DispatchQueue.global(qos: .background).async {
            let downloadTask: URLSessionDataTask = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
                if (error != nil) {
                    DispatchQueue.main.async(execute: { () -> Void in
                        let staticImg = UIImage(named: urlString)
                        completionHandler(staticImg, urlString)
                    })
                    return
                }
                if data != nil {
                    let image = UIImage(data: data!)
                    self.cache.setObject(image as AnyObject, forKey: urlString as AnyObject)
                    DispatchQueue.main.async(execute: { () -> Void in
                        if let image = image {
                            completionHandler(image, urlString)
                        } else {
                            completionHandler(nil, urlString)
                        }
                    })
                    return
                }
            })
            downloadTask.resume()
        }
        
    }
    
    func thumbnailForUrl(_ urlString: String, completionHandler:@escaping (_ image: UIImage?, _ url: String) -> ()) {
        let image = self.cache.object(forKey: urlString as AnyObject) as? UIImage
        
        if image != nil {
            DispatchQueue.main.async(execute: { () -> Void in
                completionHandler(image, urlString)
            })
            return
        }
        DispatchQueue.global(qos: .background).async {
            
            let asset = AVAsset(url: URL(string: urlString)!)
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            let time = CMTimeMakeWithSeconds(Float64(1), preferredTimescale: 100)
            do {
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: img)
                self.cache.setObject(thumbnail as AnyObject, forKey: urlString as AnyObject)
                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(thumbnail, urlString)
                })
            } catch {
                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(nil, urlString)
                })
            }
        }
        
    }
}
