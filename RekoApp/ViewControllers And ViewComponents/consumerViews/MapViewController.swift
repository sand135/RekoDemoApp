//
//  MapViewController.swift
//  RekoApp
//
//  Created by Sandra Sundqvist on 2019-04-09.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {

   @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    let locationManger = CLLocationManager()
    private let permissionDeniedMessage = "For showing your position, go to settings and accept that this app can use your location."
    private let restrictedPermissionMessage = "This app cannot use your location due to your security settings."
    private let locationServicesOffMessage = "Please turn on your locationservices in settings!"
    private let regionDiameter: CLLocationDistance = 12000
    private let locationZoomDiameter: CLLocationDistance = 8000
    private var locations = [RekoLocation]()
    var backToUserLocationButton: MKUserTrackingBarButtonItem?
    private let db = DatabaseHandler.getDatabaseHandlerInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        checkLocationServices()
        loadAllRekoLocationsFromDbOntoMap()
        backToUserLocationButton = MKUserTrackingBarButtonItem(mapView:self.mapView)
        
        
        self.toolbarItems?.append(backToUserLocationButton!)
        
        self.setToolbarItems(self.toolbarItems, animated: false)
        //self.navigationItem.rightBarButtonItem = backToUserLocationButton;
        self.searchBar.delegate = self
        self.dissmissKEyboardWhenTapping()
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var searchResults = [RekoLocation]()
        for location in locations{
            if location.name!.uppercased().contains(searchText.uppercased()){
                searchResults.append(location)
            }
        }
        if searchResults.count == 1 {
            centerViewOnAnnotationLocation(location: searchResults[0])
        }
    }
    
    func loadAllRekoLocationsFromDbOntoMap(){
        DatabaseHandler.getDatabaseHandlerInstance().getAllRekoLocations { (recolocationsArray) in
            for location in recolocationsArray{
                self.locations.append(location)
            }
            self.setOutRekoAnnotationsOnMap()
        }
    }
    

    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkForLocationPermissions()
        }else{
            showToast(message: locationServicesOffMessage)
        }
    }
    
    func setupLocationManager(){
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkForLocationPermissions(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManger.startUpdatingLocation()
        case .denied:
            self.showToast(message: permissionDeniedMessage)
        case .notDetermined:
            locationManger.requestWhenInUseAuthorization()
        case .restricted:
            self.showToast(message: restrictedPermissionMessage)
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else{return}
        let title: String?
        if let t = view.annotation?.title{
            title = t
        }else{
            title = ""
        }
        showActionPopupWith(title: title!, annotation: annotation)
    }
    
    func showActionPopupWith(title: String, annotation: MKAnnotation){
       
        let actionPopUp = UIAlertController(title:title, message: nil, preferredStyle: .actionSheet)
        
        actionPopUp.addAction(UIAlertAction(title: "Add to mine Reko", style: .default, handler: { (action: UIAlertAction) in
            
            if let currentUser = LocalUserHandler.getInstance().getCurrentLocalUser(){
                for location in self.locations{
                    if annotation.coordinate.latitude == location.latitude && annotation.coordinate.longitude == location.longitude{
                        currentUser.rekoLocation = location
                        self.db.update(user: currentUser)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }))
        //Cancel-button that returns to previous view
        actionPopUp.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionPopUp, animated: true, completion: nil)
    }
    
    func centerViewOnAnnotationLocation(location: RekoLocation){
        guard let latitude = location.latitude else{return}
        guard let longitude = location.longitude else{return}
        let locationCordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let location = MKCoordinateRegion.init(center: locationCordinate, latitudinalMeters: locationZoomDiameter, longitudinalMeters: locationZoomDiameter)
        mapView.setRegion(location, animated: true)
    }
    
    func centerViewOnUserLocation(){
        guard let location = locationManger.location?.coordinate else{return}
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionDiameter, longitudinalMeters: regionDiameter)
        mapView.setRegion(region, animated: true)
    }
    
    
    //MARK: Annotations
    
    func setOutRekoAnnotationsOnMap(){
        var mapAnnotations = [MKAnnotation]()
        for location in locations{
            let annotation = RekoAnnotations(withLocation: location)
            mapAnnotations.append(annotation)
        }
        mapView.addAnnotations(mapAnnotations)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkForLocationPermissions()
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
    }

}
