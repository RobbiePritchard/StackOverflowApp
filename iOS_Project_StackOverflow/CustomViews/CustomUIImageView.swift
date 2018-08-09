//
//  CustomUIImageView.swift
//  iOS_Project_StackOverflow
//
//  Created by Robbie Pritchard on 8/3/18.
//  Copyright © 2018 Robbie Pritchard. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

class CustomUIImageView: UIImageView {
    
    private var urlString: String?
    
    
    func downloadImage(from link:String, contentMode: UIView.ContentMode = .scaleAspectFill) {
        
        
        //Make sure the url is valid
        urlString = link
        guard let url = URL(string: urlString!) else{
            return
        }
        
        // image is set to nil to avoid reuse issues
        image = nil
        
        //check if image is already in cache if so load it
        if let imageFromCache = imageCache.object(forKey: link as NSString){
            self.image = imageFromCache
            self.contentMode = contentMode
            
            return
        }
        
        // download image if image is not in cache
        URLSession.shared.dataTask(with: url){(data, response, error) in
            DispatchQueue.main.async {
                
                if let data = data {
                    
                    //if we dont have an image (url is broke) return a blank image
                    guard let image = UIImage(data: data) else{
                        imageCache.setObject(UIImage(), forKey: link as NSString)
                        return
                    }
                    
                    // we have an image!
                    if link == self.urlString{
                        self.contentMode = contentMode
                        self.image = image
                    }
                    
                    // add image to the cache
                    imageCache.setObject(image, forKey: link as NSString)
                    
                }
            }
            }.resume()
    }
}

