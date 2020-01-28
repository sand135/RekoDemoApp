//
//  productDetailViewController.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-16.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import UIKit

class productDetailViewController: UIViewController {
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageVIew: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var amountLeftLabel: UILabel!
    var product = Product()
    var orderAmount: Int?
    var amountLeftOfProduct: Int?
    var totalPrice: Double?
    let db = DatabaseHandler.getDatabaseHandlerInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SelectedCellHelper.selectedProduct == nil{
            self.navigationController?.popViewController(animated: true)
        }
        product = SelectedCellHelper.selectedProduct!
        setViewFromSelectedProduct()
        
        
    }
    
    func setViewFromSelectedProduct(){
        setPictureFrom(product: product)
        productNameLabel.text = product.name
        descriptionLabel.text = product.pDescription
        unitLabel.text = product.unit
        amountLeftLabel.text = "\(product.amount ?? 0)"
        priceLabel.text = "Price: \(product.price ?? 0)"
        currencyLabel.text = product.currency
        
    }
    
    func setPictureFrom(product:Product){
        guard let imageURL = product.imageUrl else{return}
        guard let url = URL(string: imageURL) else{return}
        ImageLoader.loadPictureFrom(url: url, into: self.productImageVIew) { (didComplete) in
        }
        
    }
    
    @IBAction func orderButtonPressed(_ sender: UIButton) {
        guard let currentUser = LocalUserHandler.getInstance().getCurrentLocalUser() else{return}
        guard let producerId = product.producerId else {return}
        guard let location = currentUser.rekoLocation else{return}
        guard let currentUserId = currentUser.userId else{return}
        if orderAmount == nil || orderAmount == 0 {
            self.showToast(message: "Please enter how many you want to order!")
            return
        }
        
        let order = Order(name: product.name ?? "", amount: orderAmount!, price: totalPrice ?? 0, user: currentUser, producerId: producerId, producerName: product.producerName ?? "", location: location, currentUserId: currentUserId)
        
        
        db.addNew(order: order) { (didComplete) in
            if didComplete{
              self.updateProduct()
                self.showToast(message: "Order was successfully added!"){(_) in
                    self.performSegue(withIdentifier: "detailToOrdersView", sender: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else{
                self.showToast(message: "Order could not be added. Try again later"){(_) in
                    
                }
            }
        }
    }
    
    func updateProduct(){
        self.product.amount = self.amountLeftOfProduct
        db.update(product: self.product) { (_) in}
    }
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        if let amount = SelectedCellHelper.selectedProduct?.amount{
            self.amountLeftOfProduct = amount - Int(sender.value)
            if self.amountLeftOfProduct! < 0{
                sender.value = Double(amount)
                self.amountLeftOfProduct = 0
            }else{
                orderAmount = Int(sender.value)
                amountLabel.text = "\(Int(sender.value))"
                amountLeftLabel.text = "\(amountLeftOfProduct!)"
                if let productPrice = product.price{
                self.totalPrice = productPrice * sender.value
                    totalPriceLabel.text = "\(self.totalPrice ?? 0)"
                }
            }
           
        }
    }
    
   
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
