//
//  AsyncImageView.swift
//  YoutubeTestAPI
//
//  Created by Sergio Veliz on 11/15/18.
//  Copyright © 2018 Sergio Veliz. All rights reserved.
//

import Foundation
import UIKit

var asyncImageCashArray = NSCache<NSString, UIImage>()

class AsyncImageView: UIImageView {
    
    private var currentURL: NSString?
    
    func loadAsyncFrom(url: String, placeholder: UIImage?) {
        let imageURL = url as NSString
        if let cashedImage = asyncImageCashArray.object(forKey: imageURL) {
            image = cashedImage
            return
        }
        image = placeholder
        currentURL = imageURL
        guard let requestURL = URL(string: url) else { image = placeholder; return }
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            DispatchQueue.main.async { [weak self] in
                if error == nil {
                    if let imageData = data {
                        if self?.currentURL == imageURL {
                            if let imageToPresent = UIImage(data: imageData) {
                                asyncImageCashArray.setObject(imageToPresent, forKey: imageURL)
                                self?.image = imageToPresent
                            } else {
                                self?.image = placeholder
                            }
                        }
                    } else {
                        self?.image = placeholder
                    }
                } else {
                    self?.image = placeholder
                }
            }
        }.resume()
    }
    
}
