//
//  extension String.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-29.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import Foundation

extension String {
    
    //Checks i a string contains of only numbers and .
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
        return Set(self).isSubset(of: nums)
    }
}
