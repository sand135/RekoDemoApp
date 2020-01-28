//
//  OrdersViewController.swift
//  
//
//  Created by Sandra Sundqvist on 2019-04-24.
//

import UIKit

class OrdersForProducerViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, DataDownloadDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var orderList = [Order]()
    var db = DatabaseHandler.getDatabaseHandlerInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        db.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let currentUserID = LocalUserHandler.getInstance().getCurrentLocalUser()?.userId {
            db.getAllOrdersMadeFor(userId: currentUserID)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //Avregistrerar lyssnare i databasen
        db.detachListenerForProducersOrders()
    }
    
    //MARK: Tableviewmethods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! producersOrderTableViewCell
        cell.configureForProducerWith(order: orderList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.showStatusAlertMessage(for: indexPath.row)
        return indexPath
    }
    
    func showStatusAlertMessage(for row: Int){
        
        var order = orderList[row]
        let alert = UIAlertController(title: "Edit order status", message: "Order: \(order.name ?? "") amount: \(order.amount ?? 0)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
            order.status = .confirmed
            self.db.update(order: order)
        }))
        alert.addAction(UIAlertAction(title: "Deny", style: .default, handler: { (action) in
            order.status = .denied
            self.db.update(order: order)
        }))
        alert.addAction(UIAlertAction(title: "Deliver", style: .default, handler: { (action) in
            order.status = .delivered
            self.db.update(order: order)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Delegatemethods
    
    func orderForProducersDidFinishDownloading() {
        setList()
    }
    
    func setList(){
        orderList.removeAll()
        for order in db.orderListForProducer{
            orderList.append(order)
        }
        sortListByCustomerNameAscending()
        tableView.reloadData()
    }
    
   
    @IBAction func homeButtonPressed(_ sender: UIButton) {
        self.tabBarController?.dismiss(animated: true, completion:  nil)
    }
    
    func sortListByCustomerNameAscending(){
        self.orderList = self.orderList.sorted(by: { (Obj1, Obj2) -> Bool in
            let Obj1_Name = Obj1.user?.name ?? ""
            let Obj2_Name = Obj2.user?.name ?? ""
            return (Obj1_Name.localizedCaseInsensitiveCompare(Obj2_Name) == .orderedAscending)
        })
    }



}
