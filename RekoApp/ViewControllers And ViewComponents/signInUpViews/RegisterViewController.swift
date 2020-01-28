//
//  RegisterViewController.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-03.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var emailTextInput: UITextField!
    @IBOutlet weak var passwordFirstTextInput: UITextField!
    @IBOutlet weak var passwordSecondTextInput: UITextField!
    @IBOutlet weak var userNameTextInput: UITextField!
    
    private let emailAlertMessage = "Email cannot be empty!"
    private let passwordsDontMatchAlertMessage = "Passwords don't match!"
    private let passwordEmptyAlert = "Password cannot be empty!"
    private let passwordTooShortAlert = "Password is too short! Use min 6 characters."
    private let noUserNameAlertMessage = "Please enter a user name!"
    private let registrationFailedMessage = "Registration failed! E-mail is probably aldready in use."
    private var db = DatabaseHandler.getDatabaseHandlerInstance()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dissmissKEyboardWhenTapping()
    }
    

    //MARK: RegisterButton
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if(emailAndPasswordFieldsAreValid()){
            //sets up new user in database
            self.db.signUpWith(userName: userNameTextInput.text! ,email: emailTextInput.text!, password: passwordFirstTextInput.text!) { (wasSuccessfull) in
                if wasSuccessfull{
                    LocalUserHandler.getInstance().didRegister = true
                    self.performSegue(withIdentifier: "registerToHomeSegue", sender: nil)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.showToast(message: self.registrationFailedMessage)
                }
            }
        }
    }
    
    func emailAndPasswordFieldsAreValid() -> (Bool) {
       
        guard userNameTextInput.text != "" else {
            self.showToast(message: noUserNameAlertMessage)
            return false
        }
        
        guard emailTextInput.text != "" else{
            self.showToast(message: emailAlertMessage)
            return false
        }
        guard passwordFirstTextInput.text != "" else {
            self.showToast(message: passwordEmptyAlert)
            return false
        }
        
        guard passwordFirstTextInput.text?.count ?? 0 >= 6 else{
            self.showToast(message: passwordTooShortAlert)
            return false
        }
        
        if passwordFirstTextInput.text != passwordSecondTextInput.text{
            self.showToast(message: passwordsDontMatchAlertMessage)
            return false
        }
        return true
    }

    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
