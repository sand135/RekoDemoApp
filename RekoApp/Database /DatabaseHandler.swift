//
//  Database.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-03.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

/**
 *Class that handles all queries betwwen app and database (firebase- Cloud firestore, storage and authentication) Use the GetInstance-property to access functions.
 */
class DatabaseHandler: NSObject{
    
    
    private enum downloadingType {
        case user
        case products
        case orders
        case ordersForProducer
    }
  
    
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private static var databaseInstance: DatabaseHandler?
    var delegate: DataDownloadDelegate?
    var productArray = [String]()
    private var listenerForProductsUpdates: ListenerRegistration?
    private var listenerForUserProducts: ListenerRegistration?
    private var  listenerForUserChanges: ListenerRegistration?
    private var listenerForOrdersUpdates: ListenerRegistration?
    private var listenerForOrdersToProducer: ListenerRegistration?
   
    private let userCollectionName = "users"
    private let locationsCollectionName = "Rekolocations"
    private let ordersForMeDocumentName = "ordersForMe"
    private let productsCollection = "products"
    var orderList = [Order]()
    var orderListForProducer = [Order]()
    var productsList = [Product]()
    
    override private init() {
        //Use getDatabase for databaseInstance
    }
    
    
    static func getDatabaseHandlerInstance() -> DatabaseHandler {
        if databaseInstance == nil{
            databaseInstance = DatabaseHandler()
        }
        return databaseInstance!
    }
    
    
    
     //MARK: Cloud firestore functions
    
    func setupCurentUserListener(userId: String){
        listenerForUserChanges = db.collection(userCollectionName).whereField("userId", isEqualTo: userId)
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    
                    if (diff.type == .added) {
                        print("New item: \(diff.document.data())")
                        let user = LocalUser(withDictionary: diff.document.data())
                        LocalUserHandler.getInstance().setCurrentUser(user: user)
                    }
                    if (diff.type == .modified) {
                        print("Modified item: \(diff.document.data())")
                        LocalUserHandler.getInstance().setCurrentUser(user: LocalUser(withDictionary:diff.document.data()))
                    }
                    if (diff.type == .removed){
                        print ("document removed \(diff.document.data()) ")
                        self.logOut()
                    }
                }
                self.didDownloadData(type: .user)
        }
    }

    
    //MARK: downloading-methods
    func getAllRekoLocations(completion: @escaping([RekoLocation])->Void){
        var locations = [RekoLocation]()
        db.collection(self.locationsCollectionName)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(locations)
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let longitude:Double = document.data()["longitude"] as? Double ?? 0.0
                        print("\(longitude)")
                        let newLocation = RekoLocation(withDictionary: document.data())
                        newLocation.id = document.documentID
                        locations.append(newLocation)
                    }
                    completion(locations)
                }
        }
    }
    
    
    /**
     fetch products from database for specific user
     **/
    func getProductsUploadedBy(userId: String, onCompletion: @escaping([Product])->Void){
        
        var products = [Product]()
        db.collection(self.productsCollection).whereField("producerId", isEqualTo: userId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    onCompletion(products)
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let longitude:Double = document.data()["longitude"] as? Double ?? 0.0
                        print("\(longitude)")
                        let newProduct = Product(withDictionary: document.data())
                        newProduct.id = document.documentID
                        products.append(newProduct)
                    }
                    onCompletion(products)
                }
        }
        
    }
    
    func getAllProductsFor(rekoLocationId: String){
        detachListenerForProductList()
        productsList.removeAll()
        listenerForProductsUpdates = db.collection(productsCollection).whereField("rekolocationsId", arrayContains: rekoLocationId )
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        print("New item: \(diff.document.data())")
                        let newProduct = Product(withDictionary: diff.document.data())
                        newProduct.id = diff.document.documentID
                        self.productsList.append(newProduct)
                    }
                    if (diff.type == .modified) {
                        print("Modified item: \(diff.document.data())")
                        let changedProduct = Product(withDictionary: diff.document.data())
                        changedProduct.id = diff.document.documentID
                        for i in 0..<self.productsList.count {
                            if(self.productsList[i].id == changedProduct.id){
                                self.productsList.remove(at: i)
                                self.productsList.append(changedProduct)
                            }
                        }
                        
                    }
                    if (diff.type == .removed) {
                        print("Removed item: \(diff.document.data())")
                        
                    }
                }
                self.didDownloadData(type: .products)
        }
    }
    
    
    func getAllOrdersMadeBy(userId: String) {
        orderList.removeAll()
        listenerForOrdersUpdates = db.collection(userId).document("ordersMadeByMe").collection("orders")
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    
                    if (diff.type == .added) {
                        print("New order: \(diff.document.data())")
                        print("id: \(diff.document.documentID)")
                        var order = Order(withDictionary: diff.document.data())
                        order.id = diff.document.documentID
                        self.orderList.append(order)
                    }
                    if (diff.type == .modified) {
                        print("Modified order: \(diff.document.data())")
                        var modifiedOrder = Order(withDictionary: diff.document.data())
                        modifiedOrder.id = diff.document.documentID
                        for i in 0..<self.orderList.count{
                            if modifiedOrder.id == self.orderList[i].id{
                                self.orderList.remove(at: i)
                                self.orderList.append(modifiedOrder)
                            }
                        }
                    }
                }
                
                self.didDownloadData(type: .orders)
        }
    }
    
    
    func getAllOrdersMadeFor(userId: String) {
        orderListForProducer.removeAll()
        listenerForOrdersToProducer = db.collection(userId).document(ordersForMeDocumentName).collection("orders")
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    
                    if (diff.type == .added) {
                        var order = Order(withDictionary: diff.document.data())
                        order.id = diff.document.documentID
                        self.orderListForProducer.append(order)
                    }
                    if (diff.type == .modified) {
                        print("Modified order for:\(userId) with data: \(diff.document.data())")
                        var modifiedOrder = Order(withDictionary: diff.document.data())
                        modifiedOrder.id = diff.document.documentID
                        for i in 0..<self.orderListForProducer.count{
                            if modifiedOrder.id == self.orderListForProducer[i].id{
                                self.orderListForProducer.remove(at: i)
                                self.orderListForProducer.append(modifiedOrder)
                            }
                        }
                    }
                }
                self.didDownloadData(type: .ordersForProducer)
        }
    }
    
    //MARK: updating-functions
    
    func update(user: LocalUser){
        guard let userId = user.userId else{return}
        db.collection(userCollectionName).document(userId).setData(user.convertUserToDictionaryFormat()) { err in
            if let err = err {
                print("Error writing document: \(err)")
                
            } else {
                print("Document successfully written!")
              
            }
        }
        
        
    }
    
    func update(product: Product, onCompletion:@escaping(Bool)->Void){
        guard let productId = product.id else{
            onCompletion(false)
            return}
        db.collection(productsCollection).document(productId).setData(product.convertToDictinoaryFormat()) { err in
            if let err = err {
                print("Error writing document: \(err)")
                onCompletion(false)
            } else {
                print("Document successfully written!")
                onCompletion(true)
            }
        }
    }
    
    func update(order: Order){
        guard let producerId = order.producerId else{return}
        guard let customerId = order.customerId else{return}
        guard let orderId = order.id else{return}
        let updatedOrder = order.convertToDictionaryObject()
        //update order for customer
        db.collection(customerId).document("ordersMadeByMe").collection("orders").document(orderId).setData(updatedOrder){ err in
            if let err = err{
                print("Error updating order for customer \(err)")
            } else {
                print("Order wit id: \(orderId) successfully updated for customer")
            }
        }
        //update order in for producer
        db.collection(producerId).document(ordersForMeDocumentName).collection("orders").document(orderId)
            .setData(updatedOrder) { err in
                if let err = err{
                    print("Error updating order for producer \(err)")
                } else {
                    print("Order with id: \(orderId) successfully updated for producer")
                }
        }
        
        
    }
    
    //MARK: Adding methods
    
    func addNew(user: LocalUser){
        guard let userId = user.userId else{
            return
        }
        let newUserObject = user.convertUserToDictionaryFormat()
        db.collection(self.userCollectionName).document(userId).setData(newUserObject){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(userId)")
            }
        }
    }
    
    func addNew(order: Order, oncompletion:@escaping(Bool)-> Void){
        let orderId = UUID().uuidString
        guard let currentUserId = LocalUserHandler.getInstance().getCurrentLocalUser()?.userId else{return}
        guard let ordeProducerId = order.producerId else{return}
        
        
        let newOrder = order.convertToDictionaryObject()
        db.collection(currentUserId).document("ordersMadeByMe").collection("orders").document(orderId).setData(newOrder){ err in
            if let err = err{
                print("Error adding document: \(err)")
            } else {
                print("Order added to usercollectionID: \(currentUserId)")
            }
        }
        db.collection(ordeProducerId).document(ordersForMeDocumentName).collection("orders").document(orderId).setData(newOrder){ err in
            if let err = err{
                print("Error adding document: \(err)")
                oncompletion(false)
            } else {
                print("Order also added to producercollectionID: \(ordeProducerId)")
                oncompletion(true)
            }
        }
        
    }
    
    func add(product: Product, onCompletion: @escaping(Bool)->Void) {
        //sätter till ett nytt läxobjekt i firestore
        let newDictionaryObject = product.convertToDictinoaryFormat()
        var ref:DocumentReference?
        ref = db.collection(productsCollection).addDocument(data: newDictionaryObject) { err in
            if let err = err {
                print("Error adding document: \(err)")
                onCompletion(false)
            } else {
                print("Document added with ID: \(ref!.documentID)")
                onCompletion(true)
            }
        }
    }
    
    
    func add(newProduct: Product, with image: UIImage, onCompletion: @escaping(Bool)->Void){
        self.upLoad(image: image) { (urlString, imageName) in
            newProduct.imageUrl = urlString
            newProduct.imageName = imageName
            self.add(product: newProduct, onCompletion: { (didComplete) in
                if didComplete{
                    onCompletion(true)
                }else{
                onCompletion(false)
                }
            })
            
        }
    }
    
    private func upLoad(image: UIImage, onCompletion: @escaping(_ url:String, _ name:String)->Void){
        //Skapar ett unikt namn för varje bild
        let uniqueImageId = NSUUID().uuidString
        let imagename = "\(uniqueImageId).png"
        
        //hämtar en referens till "databasutrymmet" och skapar ett "barn" där bilden kommer att sparas
        let storageRef = storage.reference().child(imagename)
        guard let imageAsPngData = image.pngData() else{return}
        
        storageRef.putData(imageAsPngData, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error as Any)
                return
            }else{
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil{
                        return
                    }else{
                        if(url != nil){
                            onCompletion((url!.absoluteString), imagename)
                        }
                    }
                })
            }
            
        }
    }
    
    
    //MARK: -DataDownloading-Delegatefunctions
    private func didDownloadData(type: downloadingType){
        switch type {
        case .user:
            delegate?.userDataDidFinishDownloading!()
        case .products:
            delegate?.productDataDidFinishDownloading!()
        case .orders:
            delegate?.orderDataDidFinishDowloading!()
        case .ordersForProducer:
            delegate?.orderForProducersDidFinishDownloading!()
        }
    }
    
    //MARK: DetachListenersFunctions
    
    func detachListeners() {
        //Deletes listener for realtimeupdates for...
        detachListenerForUserChanges()
        detachListenerForOrderList()
        detachListenerForProductList()
    }
    
    func detachListenerForUserChanges(){
        listenerForUserChanges?.remove()
    }
    
    func detachListenerForProductList(){
        listenerForProductsUpdates?.remove()
    }
    
    func detachListenerForOrderList(){
        listenerForOrdersUpdates?.remove()
    }
    
    func detachListenerForProducersOrders(){
        listenerForOrdersToProducer?.remove()
    }
    
   
    
    //MARK: AuthenticationFunctions
    
    private let authDb = Auth.auth()
    private var handle: AuthStateDidChangeListenerHandle?
    
    
    
    func logOut() {
        do {
            try authDb.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    func setUpListenerForLogedOnUser() {
        handle = authDb.addStateDidChangeListener { (auth, user) in
            if let currentuser = user{
                self.setupCurentUserListener(userId: currentuser.uid)
                print("Current userId: \(currentuser.uid) from listener")
            }else{
                print("current user = nil")
            }
        }
    }
    
    func removeListenerForLogedOnUser(){
        guard handle != nil else{return}
        authDb.removeStateDidChangeListener(handle!)
    }
    
    func getCurrentAuthenticatedUser() -> User? {
        return authDb.currentUser
    }
    
    func signUpWith(userName: String, email: String, password: String, onCompletion: @escaping(Bool)->Void) {
        authDb.createUser(withEmail: email, password: password) { authResult, error in
            if(error == nil){
                let user = LocalUser(name: userName , email: email)
                user.userId = self.getCurrentAuthenticatedUser()?.uid
                self.addNew(user: user)
                onCompletion(true)
                print(" Sign up successfull! + \(authResult as Any)")
            }else{
                onCompletion(false)
                print("Error in signup!")
            }
        }
    }
    
    func signInWith(email: String, password: String, onSuccess: @escaping(Bool)->Void){
        authDb.signIn(withEmail: email, password: password) { [weak self] user, error in
            if error != nil {
                print(error.debugDescription)
                onSuccess(false)
                return
            }
            onSuccess(true)
        }
        
    }

    

}
