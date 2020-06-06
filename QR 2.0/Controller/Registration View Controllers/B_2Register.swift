//
//  B_2Register.swift
//  QR 2.0
//
//  Created by Sebastian Barry on 5/24/20.
//  Copyright © 2020 Sebastian Barry. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import GooglePlaces
import GoogleMaps



//this is the OWNER view controller register class
class B_2Register : UIViewController {
    
    @IBOutlet weak var nameConfirmButton: UIButton!
    @IBOutlet weak var addressConfirmButton: UIButton!
    var confirmedAddress : Bool?
    var confirmedName : Bool?
    var businessName : String?
    var businessAddress : String?
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    let db = Firestore.firestore()
    @IBOutlet weak var NameLabel : UILabel!
    @IBOutlet weak var checkMarksLabel: UILabel!
    @IBOutlet weak var AddressLabel: UILabel!
    @IBOutlet weak var ConfirmButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        // Remove the background color.
        navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
        
        // Set the shadow color.
        navigationController?.navigationBar.shadowImage = UIColor.clear.as1ptImage()
        //double checking what the user selected as usertype
        print("User selected: ", GlobalVariables.ActualIDs.ActualUserType!)
        
        //this is the code from google api
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.placeholder = "Lookup your business."
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        GlobalFunctions.setButtonRadius(button: self.ConfirmButton)
        //instnatinate these as false when the user opens the screen
        self.confirmedName = false
        self.confirmedAddress = false
        self.ConfirmButton.isHidden = true
        self.nameConfirmButton.isHidden = true
        self.addressConfirmButton.isHidden = true
        self.checkMarksLabel.isHidden = true
        self.searchController?.searchBar.text = nil
        
    }
    
    

    //confirm the global variables as the business name data
    //move to the next screen.
    @IBAction func BusinessConfirm(_ sender: UIButton) {
        
        
        if confirmedAddress == true && confirmedName == true {
            GlobalVariables.ActualIDs.ActualBusinessName = self.businessName
            GlobalVariables.ActualIDs.ActualZipCode = self.businessAddress
            self.performSegue(withIdentifier: GlobalVariables.SegueIDs.PostBusinessSearchSegue, sender: self)
        } else {self.errorLabel.text = "Please check the marks to confirm."}
        
    }
    
    
    
    @IBAction func ConfirmNameAction(_ sender: UIButton) {
        self.nameConfirmButton.tintColor = .green
        self.confirmedAddress = true
        if self.confirmedName == true {
            self.checkMarksLabel.textColor = .lightGray
            self.ConfirmButton.isHidden = false
        }
    }
    
    @IBAction func ConfirmAddress(_ sender: UIButton) {
        self.addressConfirmButton.tintColor = .green
        self.confirmedName = true
        if self.confirmedAddress == true {
            self.checkMarksLabel.textColor = .lightGray
            self.ConfirmButton.isHidden = false
        }
    }
    
    //alert notification
    func cancelAlert(title : String?, message : String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            //insert the function to delete a piece of data from the collection
            
            
            alert.dismiss(animated: true, completion: nil)
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        
        self.present(alert, animated: true)
    }
    
    //create the notification
    @IBAction func CancelButton(_ sender: UIButton) {
        self.cancelAlert(title: "Cancel Process?", message: "This will take you back home")
    }
    
    
}


//this extension is from the api
extension B_2Register: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        searchController?.searchBar.text = place.name
        self.businessAddress = place.formattedAddress
        self.businessName = place.name
        self.AddressLabel.text = place.formattedAddress
        self.NameLabel.text = place.name
        self.addressConfirmButton.tintColor = .gray
        self.nameConfirmButton.tintColor = .gray
        self.ConfirmButton.isHidden = true
        self.confirmedName = false
        self.confirmedAddress = false
        self.addressConfirmButton.isHidden = false
        self.nameConfirmButton.isHidden = false
        self.checkMarksLabel.isHidden = false
        self.checkMarksLabel.textColor = .black
        // Do something with the selected place.
        //print("Place name: \(place.name)")
        //print("Place address: \(place.formattedAddress)")
        //print("Place attributions: \(place.attributions)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}











