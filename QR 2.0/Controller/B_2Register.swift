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
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    let db = Firestore.firestore()
   // @IBOutlet weak var BusinessNameTextField: UITextField!
    //@IBOutlet weak var ZipCodeTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ConfirmPasswordTextField: UITextField!
    @IBOutlet weak var ErrorLabel : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    
    @IBAction func ConfirmData(_ sender: UIButton) {
        
        //the next few lines set the global data variables as the textfield user inputted data for use in data set.
        GlobalVariables.ActualIDs.ActualEmail = EmailTextField.text
        GlobalVariables.ActualIDs.ActualPassword = PasswordTextField.text
        //***Still need to set the address
        SetupNewUser()

        
    }
    
    //create a new list with the new variables
    func InstantiateOwnerList() -> [String : Any] {
        
        let NewUser = [
            
            GlobalVariables.UserIDs.UserEmail: GlobalVariables.ActualIDs.ActualEmail, //(0)
            GlobalVariables.UserIDs.BusinessName : GlobalVariables.ActualIDs.ActualBusinessName, //(1)
            GlobalVariables.UserIDs.UserPassword: GlobalVariables.ActualIDs.ActualPassword, //(2)
            GlobalVariables.UserIDs.UserType: GlobalVariables.ActualIDs.ActualUserType, //(3)
            GlobalVariables.UserIDs.UserZipCode: GlobalVariables.ActualIDs.ActualZipCode //(4)
        ]
        
        return NewUser as [String : Any]
        
    }
    
    //setup the firebase for the new owner with a list of owner variables
    func SetupFirebaseData () {
        db.collection(GlobalVariables.UserIDs.CollectionTitle).document("\(GlobalVariables.ActualIDs.ActualEmail!)").setData(InstantiateOwnerList()) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    //setup a new user function
    func SetupNewUser () {
          
          Auth.auth().createUser(withEmail: GlobalVariables.ActualIDs.ActualEmail!, password: GlobalVariables.ActualIDs.ActualPassword!) { (user, error) in
              if let error = error {self.ErrorLabel.text = (error.localizedDescription)}
              else {
                print("Successfully created \(GlobalVariables.ActualIDs.ActualEmail!) as a \(GlobalVariables.ActualIDs.ActualUserType!)")
                self.SetupFirebaseData()
                  self.navigationController?.popToRootViewController(animated: true)
              }
          }
          
      }
    
}


//this extension is from the api
extension B_2Register: GMSAutocompleteResultsViewControllerDelegate {
      func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                             didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        searchController?.searchBar.text = place.name
        GlobalVariables.ActualIDs.ActualZipCode = place.formattedAddress
        GlobalVariables.ActualIDs.ActualBusinessName = place.name
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
    
    
    
    
    
    
    
    
    
    

