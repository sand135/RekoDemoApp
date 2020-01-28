//
//  RekoLocation.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-10.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import Foundation
import MapKit

class RekoLocation{
    
    var longitude:Double?
    var latitude: Double?
    var name: String?
    var isSelected = false
    var id: String?
    
    init(withDictionary dictionary: [String:Any]){
        self.longitude = dictionary["longitude"] as? Double
        self.latitude = dictionary["latitude"] as? Double
        self.name = dictionary["name"] as? String
        self.isSelected = dictionary["isSelected"] as? Bool ?? false
        self.id = dictionary["id"] as? String
    }
    
    func convertToDictionaryObject() -> [String:Any] {
        var dictionary = [String:Any]()
        dictionary["longitude"] = self.longitude
        dictionary["latitude"] = self.latitude
        dictionary["name"] = self.name
        dictionary["isSelected"] = self.isSelected
        dictionary["id"] = self.id
        return dictionary
    }
}
