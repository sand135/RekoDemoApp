//
//  AddProductViewController.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-24.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RadioButtonStateDelegate {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var amountTextView: UITextField!
    @IBOutlet weak var priceTextView: UITextField!
    @IBOutlet weak var rekoLocationsTableView: UITableView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var name: String?
    var price: Double?
    var amount: Int?
    var unit: String?
    var currency: String?
    var productDescription: String?
    var producerName: String?
    var producerId:String?
    var rekoLocationIds = [String]()
    var db = DatabaseHandler.getDatabaseHandlerInstance()
    var rekos = [RekoLocation]()
    

    
    //MARK: ViewLoadingMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rekoLocationsTableView.delegate = self
        self.rekoLocationsTableView.dataSource = self
        self.loadRekosFromDb()
        if EditProductHelper.editPressed{
            guard let product = EditProductHelper.selectedProduct else{
                self.showToast(message: "No product found! try again!") { (_) in
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
                return
            }
            self.setviewToEditModeFor(product: product)
        }
        
    }
    
    func setviewToEditModeFor(product: Product){
        ImageLoader.setPictureFrom(product: product, into: self.productImageView)
        productNameTextField.text = product.name
        descriptionTextView.text = product.pDescription
        amountTextView.text = "\(product.amount ?? 0)"
        priceTextView.text = "\(product.price ?? 0)"
        currencyLabel.text = product.currency
        unitLabel.text = product.unit
        //Check locations in list for product
        addButton.setTitle("Update", for: .normal)

    }
    
    func setSelectedRekosInListfrom(product: Product){
        for location in rekos {
            guard let productsRekoIds = product.rekoLocationIds else{return}
            for rekoId in productsRekoIds{
                if location.id == rekoId{
                    location.isSelected = true
                    rekoLocationIds.append(rekoId)
                }
            }
        }
        self.rekoLocationsTableView.reloadData()
    }
    
    //MARK: ImagePickerdelegatemethods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //What happens after piccker has successfully picked a image
        let image = info[.editedImage] as! UIImage
        productImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Vad som händer när Imagepickern har försökt hämta men avbryts
        picker.dismiss(animated: true, completion: nil)
    }
    
    
     //MARK: Buttons
    @IBAction func dissmissButtonPressed(_ sender: UIBarButtonItem) {
        EditProductHelper.editPressed = false
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageButtonPressed(_ sender: UIButton) {
        if EditProductHelper.editPressed {
           self.showToast(message: "Picture cannot be edited!")
        }else{
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        self.addCameraActionPopupFor(imagePickerController: imagePickerController)
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if inputsAreValid(){
            if EditProductHelper.editPressed{
                guard let product = EditProductHelper.selectedProduct else{return}
                self.updateProductInDb(product)
            }else{
                self.addNewProductToDb()
            }
        }
    }


    //MARK: TableviewMethods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rekos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductLocationCell", for: indexPath) as! ProductLocationsListTableViewCell
      
        cell.setUpCellFrom(rekoLocation: self.rekos[indexPath.row], tag: indexPath.row)
        cell.radioButtonDelegate = self
        return cell
    }
    
    
    //MARK: RadiobuttonDelegate
    func radiobuttonStateChanged(atRow: Int) {
        let location = rekos[atRow]
        if location.isSelected {
            location.isSelected = false
        } else{
            location.isSelected = true
        }
        guard location.id != nil else{return}
        //Remove location from array if loation was deselected and for preventing id to be in array two times
        for i in 0..<rekoLocationIds.count{
            if location.id == rekoLocationIds[i]{
                rekoLocationIds.remove(at: i)
            }
        }
        if location.isSelected{
            rekoLocationIds.append(location.id!)
        }
    }
    
    
    //MARK: HelpMethods
    func updateProductInDb(_ product: Product){
        product.name = self.name!
        product.price = self.price!
        product.amount = self.amount!
        product.unit = self.unit!
        product.currency = self.currency!
        product.pDescription = self.productDescription!
        product.rekoLocationIds = self.rekoLocationIds
        
        self.db.update(product: product) { (successfullyUpdated) in
            if successfullyUpdated{
                self.showToast(message: "Product Successfully updated!", onCompletion: { (_) in
                    EditProductHelper.editPressed = false
                    self.navigationController?.dismiss(animated: true, completion: nil)
                })
            }else{
                self.showToast(message: "Something went wrong! Try Again later!")
            }
        }
    }
    
    func addNewProductToDb(){
        self.activityIndicator.startAnimating()
        let product = Product(name: self.name!, price: self.price!,currency: self.currency!, amount: self.amount!, unit: self.unit!, description: self.productDescription!, producerName: self.producerName!, producerId: self.producerId!, rekoLocationsIds: self.rekoLocationIds)
        if let image = productImageView.image{
            
            db.add(newProduct: product, with: image) { (addedToDb) in
                self.activityIndicator.stopAnimating()
                if addedToDb{
                    self.showToast(message: "Product Successfully added!", onCompletion: { (_) in
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    })
                }else{
                    self.showToast(message: "Something went wrong! Try Again later!")
                }
            }
        }else{
            db.add(product: product) { (addedToDb) in
                if addedToDb{
                    self.showToast(message: "Product Successfully added!", onCompletion: { (_) in
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    })
                }else{
                    self.showToast(message: "Something went wrong! Try Again later!")
                }
            }
        }
    }
    
    
    func inputsAreValid()->Bool{
        guard productNameTextField.text != nil || productNameTextField.text != "" else {
            showToast(message: "Name of product cannot be empty!")
            return false
        }
        guard let amount = amountTextView.text else{
            showToast(message: "amount cannot be empty")
            return false
        }
        
        guard amount.isNumeric else{
            showToast(message: "insert only numbers in amount-Field")
            return false
        }
        
        guard let price = priceTextView.text else{
            showToast(message:"price cannot be empty")
            return false
        }
        
        guard price.isNumeric else{
            showToast(message:"insert only numbers in price-Field")
            return false
        }
        
        guard self.rekoLocationIds.count != 0 else{
            showToast(message: "please select at least one rekoLocation")
            return false
        }
        guard let currentUserName = LocalUserHandler.getInstance().getCurrentLocalUser()?.name else{
            showToast(message: "Cannot find producerinformation. Try to log in again or try again later!")
            return false
        }
        
        guard let currentProducerId = LocalUserHandler.getInstance().getCurrentLocalUser()?.userId else{
            showToast(message:"Cannot find producerinformation. Try to log in again or try again later!")
            return false
        }
        
        self.name = productNameTextField.text
        self.amount = Int(amount)
        self.price = Double(price)
        self.producerName = currentUserName
        self.producerId = currentProducerId
        self.currency = currencyLabel.text ?? "Euro"
        self.unit = unitLabel.text ?? "Kg"
        self.productDescription = descriptionTextView.text ?? ""
        return true
    }
    
    func loadRekosFromDb() {
        self.rekos.removeAll()
        db.getAllRekoLocations { (recolocationsArray) in
            for location in recolocationsArray{
                self.rekos.append(location)
            }
            if EditProductHelper.editPressed{
                guard let product = EditProductHelper.selectedProduct else{return}
                self.setSelectedRekosInListfrom(product: product)
            }else{
                self.rekoLocationsTableView.reloadData()
            }
        }
    }
    
   
}


