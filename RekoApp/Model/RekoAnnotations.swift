//
//  RekoAnnotations.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-11.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import UIKit
import MapKit

class RekoAnnotations: MKPointAnnotation {
    
    var id: String?
    
    
    init(withLocation location: RekoLocation){
        super.init()
        guard let latitude = location.latitude else{return}
        guard let longitude = location.longitude else{return}
        
        if let name = location.name{
            self.title = name
        }
        if let id = location.id{
            self.id = id
        }
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
    

}
