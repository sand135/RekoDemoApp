//
//  Order.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-17.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import Foundation

struct Order{
    
    enum orderStatus: Int {
        case waiting = 0
        case confirmed = 1
        case denied = 2
        case delivered = 3
    }
    
    var name: String?
    var status: orderStatus
    var amount: Int?
    var price: Double?
    var user: LocalUser?
    var producerId: String?
    var producerName: String?
    var customerId: String?
    var location: RekoLocation?
    var id: String?
   
    
    init(name: String, amount:Int, price: Double, user: LocalUser, producerId: String, producerName: String, location: RekoLocation, currentUserId: String){
        self.name = name
        self.amount = amount
        self.price = price
        self.user = user
        self.producerId = producerId
        self.producerName = producerName
        self.location = location
        self.status = .waiting
        self.customerId = currentUserId
        
    }
    
    init(withDictionary dictionary: [String:Any]) {
        self.name = dictionary["name"] as? String
        self.amount = dictionary["amount"] as? Int
        self.price = dictionary["price"] as? Double
        self.user = LocalUser(withDictionary: dictionary["user"] as? [String : Any] ?? [:])
        self.producerId = dictionary["producerId"] as?  String
        self.producerName = dictionary["producerName"] as? String
        self.location = RekoLocation(withDictionary: dictionary["location"] as? [String:Any] ?? [:])
        
        let status = dictionary["orderStatus"] as? Int
        switch status {
        case 0:
            self.status = .waiting
        case 1:
            self.status = .confirmed
        case 2:
            self.status = .denied
        case 3:
            self.status = .delivered
        default:
            self.status = .waiting
        }
        self.customerId = dictionary["customerId"] as? String
    }
    
    func convertToDictionaryObject()->[String:Any]{
        var dictionary = [String:Any]()
        dictionary["name"] = self.name
        dictionary["amount"] = self.amount
        dictionary["price"] = self.price
        dictionary["user"] = self.user?.convertUserToDictionaryFormat()
        dictionary["producerId"] = self.producerId
        dictionary["producerName"] = self.producerName
        dictionary["location"] = self.location?.convertToDictionaryObject()
        dictionary["orderStatus"] = self.status.rawValue
        dictionary["customerId"] = self.customerId
        return dictionary
    }
    
}
