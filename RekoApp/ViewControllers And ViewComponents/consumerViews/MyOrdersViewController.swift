//
//  MyOrdersViewController.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-17.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import UIKit

class MyOrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataDownloadDelegate {

    @IBOutlet weak var tableView: UITableView!
    var orderList = [Order]()
    var db = DatabaseHandler.getDatabaseHandlerInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if let userId = LocalUserHandler.getInstance().getCurrentLocalUser()?.userId{
        db.getAllOrdersMadeBy(userId: userId)
        }
        db.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        db.detachListenerForOrderList()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderTableViewCell
        cell.configureWith(order: orderList[indexPath.section])
        return cell
    }
    
    func setList(){
        orderList.removeAll()
        for order in db.orderList{
            orderList.append(order)
        }
        tableView.reloadData()
    }
    
    
    @IBAction func BackButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
 
    
    //MARK: DelegateFunctions

    func orderDataDidFinishDowloading() {
        setList()
    }
    
}
