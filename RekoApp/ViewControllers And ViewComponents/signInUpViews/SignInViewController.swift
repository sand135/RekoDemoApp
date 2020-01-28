//
//  SignInViewController.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-04.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    
    @IBOutlet weak var emailTextInput: UITextField!
    @IBOutlet weak var passwordTextInput: UITextField!
    private let db = DatabaseHandler.getDatabaseHandlerInstance()
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dissmissKEyboardWhenTapping()
    }
    
 
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        
        
        guard let email = emailTextInput.text else {
            return
        }
        guard let password = passwordTextInput.text else {
            return
        }
        
        db.signInWith(email: email, password: password) { (didSucceed) in
            if didSucceed{
                print("Login suceeded")
                self.performSegue(withIdentifier: "homeSegue", sender: nil)
            self.navigationController?.popViewController(animated: true)
            }else{
                print("login failed")
                self.showToast(message: "Login failed!")
            }
        }
    }
    
    @IBAction func backButtonPresses(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
