//
//  ProducerViewController.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-20.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import UIKit

class ProducerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var products = [Product]()
    var db = DatabaseHandler.getDatabaseHandlerInstance()

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadProductsFromDb()
    }
    
    func loadProductsFromDb(){
        if let userId = LocalUserHandler.getInstance().getCurrentLocalUser()?.userId{
            db.getProductsUploadedBy(userId: userId) { (productsFromDb) in
                self.products.removeAll()
                for product in productsFromDb{
                    self.products.append(product)
                }
                self.tableview.reloadData()
            }
        }
    }

    @IBAction func homeButtonPressed(_ sender: UIButton) {
        self.tabBarController?.dismiss(animated: true, completion:  nil)
    }
    

    @IBAction func addNewProductButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "addProductSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.configureForProducerWith(product: products[indexPath.row])
        return cell
    }

    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.showEditAlertMessage(for: indexPath.row)
        return indexPath
    }
    
    func showEditAlertMessage(for row: Int){
        let alert = UIAlertController(title: "Edit", message: "Would you like to edit \(self.products[row].name ?? "")", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Edit/Show Information", style: .default, handler: { (action) in
            EditProductHelper.selectedProduct = self.products[row]
            EditProductHelper.editPressed = true
            self.performSegue(withIdentifier: "addProductSegue", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    

}
