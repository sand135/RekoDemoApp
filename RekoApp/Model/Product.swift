//
//  Product.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-15.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import Foundation

class Product {
    
    var name: String?
    var price: Double?
    var amount: Int?
    var unit: String?
    var currency: String?
    var pDescription: String?
    var producerName: String?
    var producerId:String?
    var imageUrl: String?
    var rekoLocationIds: [String]?
    var id: String?
    var imageName: String?
    
    init(){
        
    }
    
    init(name: String, price:Double, currency: String, amount:Int, unit:String, description:String, producerName: String, producerId: String, rekoLocationsIds:[String]){
        self.name = name
        self.price = price
        self.amount = amount
        self.unit = unit
        self.pDescription = description
        self.producerName = producerName
        self.producerId = producerId
        self.rekoLocationIds = rekoLocationsIds
        self.currency = currency
    }
    
    init(withDictionary dictionary: [String: Any]){
        self.name = dictionary["name"] as? String
        self.price = dictionary["price"] as? Double
        self.currency = dictionary["currency"] as? String
        self.amount = dictionary["amount"] as? Int
        self.unit = dictionary["unit"] as? String
        self.pDescription = dictionary["description"] as? String
        self.producerName = dictionary["producerName"] as? String
        self.producerId = dictionary["producerId"] as? String
        self.imageUrl = dictionary["imageUrl"] as? String
        self.imageName = dictionary["imageName"] as? String
        self.rekoLocationIds = dictionary["rekolocationsId"] as? [String]
        self.id = dictionary["id"] as? String
        
    }
    
    func convertToDictinoaryFormat()-> [String: Any]{
        var dictionary = [String : Any]()
        dictionary["name"] = self.name
        dictionary["price"] = self.price
        dictionary["currency"] = self.currency
        dictionary["amount"] = self.amount
        dictionary["unit"] = self.unit
        dictionary["description"] = self.pDescription
        dictionary["producerName"] = self.producerName
        dictionary["producerId"] = self.producerId
        dictionary["imageUrl"] = self.imageUrl
        dictionary["imageName"] = self.imageName
        dictionary["rekolocationsId"] =  self.rekoLocationIds
        dictionary["id"] = self.id
        return dictionary
    }
    
    func updateObject(from changedProduct: Product){
        name = changedProduct.name
        price = changedProduct.price
        amount = changedProduct.amount
        currency = changedProduct.currency
        unit = changedProduct.unit
        pDescription = changedProduct.pDescription
        producerName = changedProduct.producerName
        producerId = changedProduct.producerId
        imageUrl = changedProduct.imageUrl
        imageName = changedProduct.imageName
        rekoLocationIds = changedProduct.rekoLocationIds
        id = changedProduct.id
        for ids in changedProduct.rekoLocationIds ?? [""]{
        self.rekoLocationIds?.append(ids)
        }
    }
    
}
