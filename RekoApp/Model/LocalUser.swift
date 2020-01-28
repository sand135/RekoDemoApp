//
//  User.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-05.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import Foundation

class LocalUser {
    var name: String?
    var email: String?
    var userId: String?
    var isProducer: Bool
    var rekoLocationId: String?
    var rekoLocation: RekoLocation?
    
    
    
    func convertUserToDictionaryFormat() -> [String: Any] {
        var dictionaryObject = [String:Any]()
        dictionaryObject["name"] = self.name as Any
        dictionaryObject["email"] = self.email as Any
        dictionaryObject["userId"] = self.userId as Any
        dictionaryObject["isProducer"] = self.isProducer as Any
        dictionaryObject["rekoLocationId"] = self.rekoLocationId as Any
        dictionaryObject["rekoLocation"] = self.rekoLocation?.convertToDictionaryObject()
        return dictionaryObject
    }
    
    init(withDictionary dictionary: [String: Any]){
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.userId = dictionary["userId"] as? String
        self.isProducer = dictionary["isProducer"] as? Bool ?? false
        self.rekoLocationId = dictionary["rekoLocationId"] as? String
        self.rekoLocation =  RekoLocation(withDictionary: (dictionary["rekoLocation"]) as? Dictionary ?? [:])
    }
    
    init(name: String?, email: String?){
        self.email = email
        self.name = name
        self.isProducer = false
    }
}
