//
//  DataDownloadDelegate.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-03.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import Foundation
import UIKit

@objc protocol DataDownloadDelegate {
    /**
     Runs when current userdata has finnished downloading from database
     */
    @objc optional func userDataDidFinishDownloading()
    /**
     Runs when productData for curren location has finnished downloading from database
     */
    @objc optional func productDataDidFinishDownloading()
    /**
     Runs when orderData for currentUser has finnished downloading from database
     */
    @objc optional func orderDataDidFinishDowloading()
    /**
     Runs when orderData for producersorders to currentuser has finnished downloading from database
     */
    @objc optional func orderForProducersDidFinishDownloading()
}

extension DataDownloadDelegate{
    


}
