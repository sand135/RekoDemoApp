//
//  HomeViewController.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-05.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, DataDownloadDelegate {
   
    @IBOutlet weak var forProducersButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DatabaseHandler.getDatabaseHandlerInstance().delegate =  self
        updateView()
    }
    
    func userDataDidFinishDownloading() {
        updateView()
    }
    
    func updateView(){
        if let currentUser = LocalUserHandler.getInstance().getCurrentLocalUser(){
            welcomeLabel.text = "Welcome \(currentUser.name!)"
        }
    }

    @IBAction func LogOutButtonPressed(_ sender: UIBarButtonItem) {
        DatabaseHandler.getDatabaseHandlerInstance().logOut()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func showProductsButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "HomeToProductViewSegue", sender: nil)
    }
    
    @IBAction func forProducersButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "homeToProducerViewSegue", sender: nil)
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
       DatabaseHandler.getDatabaseHandlerInstance().logOut()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
