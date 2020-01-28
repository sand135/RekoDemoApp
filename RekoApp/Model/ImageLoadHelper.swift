//
//  ImageLoadHelper.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-29.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class ImageLoader{
    
    
    static func loadPictureFrom(url: URL, into imageView: UIImageView, onCompletion: @escaping(Bool)->Void){
        //uses cocopod PinRemotImage to load and cache images from url
        imageView.pin_setImage(from: url) { (PINRemoteImageManagerResult) in
            onCompletion(true)
        }
        
    }
    
    //Sets a picture if product has one into imageView
    static func setPictureFrom(product:Product, into view: UIImageView){
        guard let imageURL = product.imageUrl else{return}
        guard let url = URL(string: imageURL) else{return}
        ImageLoader.loadPictureFrom(url: url, into: view) { (didComplete) in
            
        }
        
    }
}
