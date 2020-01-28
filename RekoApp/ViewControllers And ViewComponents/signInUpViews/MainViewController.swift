//
//  HomeViewController.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-03.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
          DatabaseHandler.getDatabaseHandlerInstance().setUpListenerForLogedOnUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //checks if a/the user is already loged in on device
        if DatabaseHandler.getDatabaseHandlerInstance().getCurrentAuthenticatedUser() != nil{
            self.performSegue(withIdentifier: "mainToHomeSegue", sender: nil)
        }
    }

    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "mainToLoginSegue", sender: nil)    
    }


}
