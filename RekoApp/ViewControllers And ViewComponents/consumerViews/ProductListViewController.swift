//
//  ViewController.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-03.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import UIKit
import Firebase

class ProductListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataDownloadDelegate, UISearchBarDelegate {
  
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var db: DatabaseHandler?
    var sortedList = [Product]()
    var searchString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        db = DatabaseHandler.getDatabaseHandlerInstance()
        db?.delegate = self
        checkUserRekoLocationAndLoadProducts()
        self.dissmissKEyboardWhenTapping()
    }

    override func viewWillAppear(_ animated: Bool) {
        if(tableView.indexPathForSelectedRow != nil){
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
       self.setList()
    }


    //MARK: Startup-helpers
    func setTitleToRekoName(){
        guard let name = LocalUserHandler.getInstance().getCurrentLocalUser()?.rekoLocation?.name else{ return}
        self.navigationItem.title = " \(name)"
    }
   
    func userDataDidFinishDownloading(){
        checkUserRekoLocationAndLoadProducts()
    }
    
    func checkUserRekoLocationAndLoadProducts(){
        if let rekolocationId = LocalUserHandler.getInstance().getCurrentLocalUser()?.rekoLocation?.id {
            setTitleToRekoName()
            db?.getAllProductsFor(rekoLocationId: rekolocationId)
        }else{
            presentLocationNotFoundPopup()
        }
    }
    
    
    func presentLocationNotFoundPopup(){
        let alert = UIAlertController(title: "No Reko-Favourite found", message: "Please choose a Rekolocation as your favourite to begin looking for products.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: { (action) in
            self.goToMapView()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: DataDownloadingDelegateMethods

    
    func productDataDidFinishDownloading() {
        self.setList()
        self.setTitleToRekoName()
    }
    
   
    
    //MARK: TableviewDelegate-methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SelectedCellHelper.selectedProduct = sortedList[indexPath.section]
        performSegue(withIdentifier: "cellToDetailSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.configureWith(product: sortedList[indexPath.section])
        return cell
    }
    
    //MARK: List settings
    
    /**
     *sets list according to productlist fetched from database and searchfield in viewcontroller
     **/
    func setList() {
        guard let allData = self.db?.productsList else {
            return
        }
        sortedList.removeAll()
        for item in allData{
            if searchString?.count ?? 0 > 0 {
                guard let name = item.name?.lowercased()else{break}
                guard let producerName = item.producerName?.lowercased() else {break}
                if name.contains(searchString!.lowercased()) || producerName.contains(searchString!.lowercased()) {
                    sortedList.append(item)
                }
            }else{
                sortedList.append(item)
            }
        }
        self.sortListByProductNameAscending()
        self.tableView.reloadData()
    }
    
    func sortListByProductNameAscending(){
        self.sortedList = self.sortedList.sorted(by: { (Obj1, Obj2) -> Bool in
            let Obj1_Name = Obj1.name ?? ""
            let Obj2_Name = Obj2.name ?? ""
            return (Obj1_Name.localizedCaseInsensitiveCompare(Obj2_Name) == .orderedAscending)
        })
    }
    
    //MARK: Searaching-functions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchText
        setList()
    }
    

    //MARK: buttons and navigations
    func goToMapView(){
        self.performSegue(withIdentifier: "productViewToMapSegue", sender: nil)
    }
    
    @IBAction func myOrdersButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "productsToOrdersView", sender: nil)
    }
    
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        self.goToMapView()
    }
    
    
    @IBAction func HomeButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
}

