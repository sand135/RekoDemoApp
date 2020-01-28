//
//  LocalUserHandler.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-09.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import Foundation

class LocalUserHandler{
    
    private var currentUser: LocalUser?
    private static var userHandler: LocalUserHandler?
    
    var didRegister = false

    
    private init(){
        
    }
    
    static func getInstance()-> LocalUserHandler{
        if userHandler == nil {
        userHandler = LocalUserHandler()
        }
        return userHandler!
    }
    
    func setCurrentUser (user: LocalUser){
        currentUser = user
    }
    
    
    func getCurrentLocalUser()-> LocalUser?{
        return currentUser
    }
    
    
    
}
